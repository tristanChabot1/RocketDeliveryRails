module Api
  class AuthController < Devise::SessionsController
    skip_before_action :verify_authenticity_token
    prepend_before_action :require_no_authentication, only: [:index]
    
    def index
      resource = User.find_for_database_authentication(email: params[:user][:email])
      if resource && resource.valid_password?(params[:user][:password])
        sign_in(resource)
        customer_id = resource.customer.id if resource.customer.present?
        courier_id = resource.courier.id if resource.courier.present?
        response_json = { success: true, customer_id: customer_id, user_id: resource.id, courier_id: courier_id }
        session[:response_json] = response_json.to_json
        respond_to do |format|
          format.html { redirect_to root_path } # Render HTML response by redirecting to the root_path
          format.json { render json: response_json } # Render JSON response
        end
      else
        render json: { success: false, email: params[:user][:email], password: params[:user][:password] }, status: :unauthorized
      end
    end

    def create
      index
    end
    
  end
end