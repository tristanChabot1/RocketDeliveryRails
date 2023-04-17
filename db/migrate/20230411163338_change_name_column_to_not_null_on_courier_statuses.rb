class ChangeNameColumnToNotNullOnCourierStatuses < ActiveRecord::Migration[7.0]
  def change
    change_column_null :courier_statuses, :name, false
  end
end
