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

end
