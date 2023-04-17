class Product < ApplicationRecord
  belongs_to :restaurant
  has_many :product_orders

  validates :restaurant, presence: { message: "can't be blank" }

  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

end
