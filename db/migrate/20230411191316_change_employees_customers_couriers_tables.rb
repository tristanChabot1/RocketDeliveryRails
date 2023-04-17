class ChangeEmployeesCustomersCouriersTables < ActiveRecord::Migration[7.0]
  def change
    remove_index :couriers, name: "index_couriers_on_user_id"
    add_index :couriers, :user_id, unique: true, name: "index_couriers_on_user_id"
    
    remove_index :customers, name: "index_customers_on_user_id"
    add_index :customers, :user_id, unique: true, name: "index_customers_on_user_id"
    
    remove_index :employees, name: "index_employees_on_user_id"
    add_index :employees, :user_id, unique: true, name: "index_employees_on_user_id"
  end
end
