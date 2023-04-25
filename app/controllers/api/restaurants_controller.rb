class Api::RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    if params[:product] && !Product.exists?(params[:product])
      render json: { error: "Invalid product ID" }, status: :unprocessable_entity
    elsif params[:rating].present? && !params[:rating].to_i.between?(1, 5)
      render json: { error: "Invalid rating or price range" }, status: :unprocessable_entity
    elsif params[:price_range].present? && !params[:price_range].to_i.between?(1, 3)
      render json: { error: "Invalid rating or price range" }, status: :unprocessable_entity
    else
      @restaurants = Restaurant.all.map do |restaurant|
        rating_average = Order.where(restaurant_id: restaurant.id).average(:restaurant_rating).round(0)
        restaurant.attributes.merge(rating_average: rating_average)
      end
      render json: @restaurants
    end
  end
  
end