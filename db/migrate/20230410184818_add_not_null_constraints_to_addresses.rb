class AddNotNullConstraintsToAddresses < ActiveRecord::Migration[7.0]
  def change
    change_column :addresses, :street_address, :string, null: false
    change_column :addresses, :city, :string, null: false
    change_column :addresses, :postal_code, :string, null: false
  end
end
