class AddCourierIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :courier, index: true, foreign_key: true
  end
end
