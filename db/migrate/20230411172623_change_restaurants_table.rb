class ChangeRestaurantsTable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :restaurants, :phone, false
    change_column_null :restaurants, :name, false
    change_column_null :restaurants, :price_range, false
    change_column_default :restaurants, :price_range, from: nil, to: 1
    change_column_null :restaurants, :active, false
    change_column_default :restaurants, :active, from: nil, to: true

    remove_index :restaurants, name: "index_restaurants_on_address_id"
    add_index :restaurants, :address_id, unique: true

  end
end
