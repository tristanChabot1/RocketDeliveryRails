json.extract! employee, :id, :user_id, :address_id, :phone, :email, :created_at, :updated_at
json.url employee_url(employee, format: :json)
