class ChangeProductsNameColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :name, false
  end
end
