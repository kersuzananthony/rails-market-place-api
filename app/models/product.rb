class Product < ActiveRecord::Base

  # Association
  belongs_to :user

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

end
