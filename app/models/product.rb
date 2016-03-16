class Product < ActiveRecord::Base

  # Association
  belongs_to :user
  has_many :placements
  has_many :orders, through: :placements

  # Validation
  validates :title, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :filter_by_title, lambda { |keyword|
    where('lower(title) LIKE ?', "%#{keyword.to_s.downcase}%")
  }

  scope :above_or_equal_to_price, lambda { |price|
    where('price >= ?', price)
  }

  scope :below_or_equal_to_price, lambda { |price|
    where('price <= ?', price)
  }

  scope :recent, lambda {
    order('updated_at')
  }

  def self.search(params = {})
    params.inspect
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all

    products = products.filter_by_title(params[:keyword]) if params[:keyword].present?
    products = products.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price].present?
    products = products.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price].present?
    products = products.recent if params[:recent].present?

    products
  end

end
