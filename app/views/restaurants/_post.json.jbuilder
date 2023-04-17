json.extract! restaurant, :id, :user_id, :address_id, :phone, :email, :name, :price_range, :active, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)
