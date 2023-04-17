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
      @restaurants = Restaurant.left_outer_joins(:orders).where("orders.restaurant_rating = ? OR orders.restaurant_rating IS NULL", params[:rating]).group(:id).select("restaurants.id, restaurants.name, restaurants.price_range, orders.restaurant_rating AS rating")
      render json: @restaurants
    end
  end
  
end