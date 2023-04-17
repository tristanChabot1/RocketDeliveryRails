class ChangeCustomersTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :customers, :phone, false
    change_column :customers, :active, :boolean, null: false, default: true
  end
end
