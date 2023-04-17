class ChangeProductOrdersTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :product_orders, :product_quantity, false
    change_column_null :product_orders, :product_unit_cost, false

    remove_index :product_orders, name: "index_product_orders_on_order_id"
    remove_index :product_orders, name: "index_product_orders_on_product_id"
    add_index :product_orders, [:order_id, :product_id], unique: true, name: "index_product_orders_on_order_id_and_product_id"
    
  end
end
