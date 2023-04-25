class Api::CouriersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @courier = Courier.find(params[:courier])
    render json: @courier.as_json.merge(primary_email: @courier.user.email)
  end

  def update
    courier = Courier.find(params[:id])
    
    if courier.update(courier_params)
      render json: { message: "Courier updated successfully" }
    else
      render json: { error: courier.errors.full_messages.join(", ") }
    end
  end
  
  private
  
  def courier_params
    params.require(:person).permit(:email, :phone)
  end
  
end