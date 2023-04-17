class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.string :description
      t.integer :cost

      t.timestamps
    end
  end
end
