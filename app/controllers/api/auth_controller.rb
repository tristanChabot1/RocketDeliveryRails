module Api
  class AuthController < Devise::SessionsController
    
    def index
      resource = User.find_for_database_authentication(email: params[:email])
      if resource && resource.valid_password?(params[:password])
        sign_in(resource)
        render json: { success: true }, status: :ok
      else
        render json: { success: false }, status: :unauthorized
      end
    end

  end
end