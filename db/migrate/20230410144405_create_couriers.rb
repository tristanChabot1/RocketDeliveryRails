class CreateCouriers < ActiveRecord::Migration[7.0]
  def change
    create_table :couriers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true
      t.references :courier_status, null: false, foreign_key: true, default: 1
      t.string :phone, null: false, limit: 255
      t.string :email, limit: 255
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
