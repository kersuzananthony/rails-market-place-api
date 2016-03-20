class Order < ActiveRecord::Base
  # Events
  before_validation :set_total!

  # Association
  belongs_to :user
  has_many :placements
  has_many :products, through: :placements

  # Validation
  validates :user_id, presence: true
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates_with EnoughProductsValidator

  def set_total!
    self.total = products.map(&:price).sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      id, quantity = product_id_and_quantity # [1,5]

      self.placements.build(product_id: id, quantity: quantity)
    end
  end
end
