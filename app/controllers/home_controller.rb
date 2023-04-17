class HomeController < ApplicationController
  def index
    if user_signed_in?
      @welcome_message = "Welcome back <strong>#{current_user.email}</strong>!".html_safe
      
    else
      @welcome_message = "Welcome <strong>Stranger</strong>.".html_safe
    end
  end
end