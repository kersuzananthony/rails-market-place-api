require 'spec_helper'

describe Product do

  let(:product) { FactoryGirl.build :product }
  subject { product }

  # Test attribute
  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  # Test default value
  it { should_not be_published }

  # Test validation
  it { should validate_presence_of :title }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }

  # Test association
  it { should belong_to :user }

  describe '.filter_by_title' do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: 'A plasma TV'
      @product2 = FactoryGirl.create :product, title: 'Fastest Laptop'
      @product3 = FactoryGirl.create :product, title: 'A beautiful TV'
      @product4 = FactoryGirl.create :product, title: 'This product has no name'
    end

    context 'When A \'TV\' pattern is sent' do

      it 'returns the 2 products matching the pattern' do
        expect(Product.filter_by_title('TV')).to have(2).items
      end

      it 'return the products matching the pattern' do
        expect(Product.filter_by_title('TV').sort).to match_array [@product1, @product3]
      end
    end
  end

  describe '.above_or_equal_to_price' do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    context 'When a price is sent' do
      it 'returns the 2 products where price is above or equal to 100' do
        expect(Product.above_or_equal_to_price(100)).to have(2).items
      end

      it 'returns the products where price is above or equal to 100' do
        expect(Product.above_or_equal_to_price(100).sort).to match_array [@product1, @product3]
      end
    end
  end

  describe '.below_or_equal_to_price' do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99
    end

    context 'When a price is sent' do
      it 'returns the 3 products where price is below or equal to 100' do
        expect(Product.below_or_equal_to_price(100)).to have(3).items
      end

      it 'returns the products where price is below or equal to 100' do
        expect(Product.below_or_equal_to_price(100).sort).to match_array [@product1, @product2, @product4]
      end
    end
  end

  describe '.recent' do
    before(:each) do
      @product1 = FactoryGirl.create :product, price: 100
      @product2 = FactoryGirl.create :product, price: 50
      @product3 = FactoryGirl.create :product, price: 150
      @product4 = FactoryGirl.create :product, price: 99

      # Update products
      @product4.touch
      @product2.touch
    end

    it 'returns the last updated products' do
      expect(Product.recent).to match_array [@product2, @product4, @product3, @product1]
    end

  end

end
