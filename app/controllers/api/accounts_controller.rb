class Api::AccountsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    account_type = params[:type].capitalize
    account_class = account_type.constantize
    account = account_class.find(params[:id])

    if account
      render json: account.as_json.merge(primary_email: account.user.email)
    else
      render json: { error: "Account not found" }, status: :not_found
    end
  end

  def update
    account = find_account

    if account.update(account_params)
      render json: { message: "#{account.class} updated successfully" }
    else
      render json: { error: account.errors.full_messages.join(", ") }
    end
  end

  private

  def find_account
    account_type = params[:type].capitalize
    account_class = account_type.constantize
    account_class.find(params[:id])
  end

  def account_params
    account_type = params[:type].capitalize
    params.permit(:email, :phone)
  end
end