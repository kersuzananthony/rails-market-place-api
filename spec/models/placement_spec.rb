require 'spec_helper'

describe Placement do

  let(:placement) { FactoryGirl.build(:placement) }

  subject { placement }

  it { should respond_to :order_id }
  it { should respond_to :product_id }

  # Test associations
  it { should belong_to :order }
  it { should belong_to :product }

end
