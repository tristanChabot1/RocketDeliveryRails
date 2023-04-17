class CreateRestaurants < ActiveRecord::Migration[7.0]
  def change
    create_table :restaurants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.string :phone
      t.string :email
      t.string :name
      t.integer :price_range
      t.boolean :active

      t.timestamps
    end
  end
end
