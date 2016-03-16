require 'spec_helper'

describe User do
  before { @user = FactoryGirl.build(:user) }

  subject { @user }

  # Test attributes
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:auth_token) }

  # Test validation
  it { should validate_uniqueness_of(:auth_token)}
  it { should be_valid }

  # Association
  it { should have_many :products }
  it { should have_many :orders }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should validate_presence_of(:email) }
  end

  describe '#generate_authentication_token!' do
    it 'generates a unique token' do
      Devise.stub(:friendly_token).and_return('auniquetoken123')
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql 'auniquetoken123'
    end

    it 'generates another token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end

  # Test destroy dependency when user is deleted
  describe '#products association'  do
    before(:each) do
      @user.save
      3.times do
        FactoryGirl.create :product, user: @user
      end
    end

    it 'destroys the associated products when self destroyed' do
      products = @user.products
      @user.destroy
      products.each do |product|
        expect(Product.find(product)).to raise_error ActiveRecord::RecordNotFound
      end
    end

  end

end
