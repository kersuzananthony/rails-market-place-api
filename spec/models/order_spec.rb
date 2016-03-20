require 'spec_helper'

describe Order do

  let(:order) { FactoryGirl.build :order }
  subject { order }

  # Test attributes
  it { should respond_to :total }
  it { should respond_to :user_id }

  # Test model validation
  # it { should validate_presence_of :total }
  it { should validate_presence_of :user_id }
  # it { should validate_numericality_of(:total).is_greater_than_or_equal_to(0) }

  # Test association
  it { should belong_to :user }
  it { should have_many :placements }
  it { should have_many(:products).through(:placements) }

  describe '#set_total!' do
    before(:each) do
      product_1 = FactoryGirl.create :product, price: 100
      product_2 = FactoryGirl.create :product, price: 85

      placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
      placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 15

      @order = FactoryGirl.build :order

      @order.placements << placement_1
      @order.placements << placement_2
    end

    it 'returns the total amount to pay for the products' do
      expect{@order.set_total!}.to change{@order.total}.from(0).to(1575)
    end
  end

  describe '#build_placements_with_product_ids_and_quantities' do
    before(:each) do
      product_1 = FactoryGirl.create :product, price: 100, quantity: 5
      product_2 = FactoryGirl.create :product, price: 85, quantity: 10

      @product_ids_and_quantities = [[product_1.id, 2], [product_2.id, 3]]
    end

    it 'builds 2 placements for the order' do
      expect{order.build_placements_with_product_ids_and_quantities(@product_ids_and_quantities)}.to change{order.placements.size}.from(0).to(2)
    end
  end

  describe '#valid?' do
    before(:each) do
      product_1 = FactoryGirl.create :product, quantity: 5, price: 50
      product_2 = FactoryGirl.create :product, quantity: 10, price: 100

      placement_1 = FactoryGirl.build :placement, product: product_1, quantity: 3
      placement_2 = FactoryGirl.build :placement, product: product_2, quantity: 12

      @order = FactoryGirl.build :order
      @order.placements << placement_1
      @order.placements << placement_2
    end

    it 'becomes invalid due to insufficient products' do
      expect(@order).to_not be_valid
    end

  end

end
