class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :product_id, presence: { message: "can't be blank" }, uniqueness: { scope: :order_id, message: "has already been taken" }
  validates :order_id, presence: { message: "can't be blank" }
  validates :product_quantity, presence: { message: "can't be blank" }, numericality: { greater_than_or_equal_to: 1 }
  validates :product_unit_cost, presence: { message: "can't be blank" }, numericality: { greater_than_or_equal_to: 0 }

  validate :product_belongs_to_same_restaurant_as_order

  private

  def product_belongs_to_same_restaurant_as_order
    if order.present? && product.present? && order.restaurant != product.restaurant
      errors.add(:product, "must belong to the same restaurant as the order")
    end
  end
  
end
