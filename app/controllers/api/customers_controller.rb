class Api::CustomersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @customer = Customer.find(params[:customer])
    render json: @customer.as_json.merge(primary_email: @customer.user.email)
  end

  def update
    customer = Customer.find(params[:id])
    
    if customer.update(customer_params)
      render json: { message: "Customer updated successfully" }
    else
      render json: { error: customer.errors.full_messages.join(", ") }
    end
  end
  
  private
  
  def customer_params
    params.require(:customer).permit(:email, :phone)
  end
  
end