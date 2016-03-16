require 'spec_helper'

describe Order do

  let(:order) { FactoryGirl.build :order }
  subject { order }

  # Test attributes
  it { should respond_to :total }
  it { should respond_to :user_id }

  # Test model validation
  it { should validate_presence_of :total }
  it { should validate_presence_of :user_id }
  it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  # Test association
  it { should belong_to :user }
  it { should have_many :placements }
  it { should have_many(:products).through(:placements) }
end
