class ChangeActiveDefaultOnCouriers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :couriers, :active, from: nil, to: true
    change_column_null :couriers, :active, false
  end
end
