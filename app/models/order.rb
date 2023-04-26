class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  belongs_to :order_status
  belongs_to :courier


  validates :customer, presence: { message: "can't be blank" }
  validates :restaurant, presence: { message: "can't be blank" }
  validates :order_status, presence: { message: "can't be blank" }

  validates :restaurant_rating, inclusion: { in: [1, 2, 3, 4, 5], allow_nil: true }

  has_many :product_orders

end
