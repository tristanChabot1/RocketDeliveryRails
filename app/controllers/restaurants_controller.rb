class RestaurantsController < ApplicationController
  before_action :authenticate_user!, :set_restaurant, only: [:show, :edit, :update]


  def index
    authenticate_user!
  
    if Employee.find_by(user_id: current_user.id).present?
      @restaurants = Restaurant.all.map do |restaurant|
        rating_average = Order.where(restaurant_id: restaurant.id).average(:restaurant_rating).round(0)
        products = restaurant.products # Get the associated products for the restaurant
  
        # Merge the restaurant attributes, rating average and products into a single hash
        restaurant.attributes.merge(rating_average: rating_average, products: products)
      end
      render json: @restaurants
    else
      redirect_to root_path
    end
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
  
    if @restaurant.save
      redirect_to @restaurant
    else
      render :new
    end
  end

  
  def update
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        format.html { redirect_to restaurant_url(@restaurant), notice: "Restaurant was successfully updated." }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    def restaurant_params
      params.require(:restaurant).permit(:user_id, :address_id, :phone, :email, :name, :price_range, :active)
    end
  
end
