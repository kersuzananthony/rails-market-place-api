class Product < ActiveRecord::Base

  # Association
  belongs_to :user

  # Validation
  validates :title, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

end
