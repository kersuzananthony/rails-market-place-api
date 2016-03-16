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

  def set_total!
    self.total = products.map(&:price).sum
  end
end
