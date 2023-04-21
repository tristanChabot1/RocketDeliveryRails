class ChangeProductUnitCostDataTypeInProductOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :product_orders, :product_unit_cost, :decimal, precision: 8, scale: 2
  end
end
