class Api::ProductsController < ApplicationController
	before_action :authenticate_user!, except: [:index]

	def index
		if params[:restaurant] && !Restaurant.exists?(params[:restaurant])
			render json: { error: "Invalid restaurant ID" }, status: :unprocessable_entity
		else
			@products = Product.all.select(:id, :name, :cost)
			render json: @products
		end
	end

end