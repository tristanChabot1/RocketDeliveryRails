Rails.application.routes.draw do
  # resources :employees
  # resources :restaurants
  # get "restaurants" => "restaurants#index"
  # get "employees" => "employees#index"

  devise_for :users, path: 'api',
  path_names: { sign_in: 'login' },
  controllers: { sessions: 'api/auth' }

  devise_scope :user do
    post '/api/login', to: 'api/auth#index'
  end

  root to: "home#index"

  get "address" => "address#show"

  namespace :api do
    post 'order/:id/status', to: 'orders#update_status'
    get '/products', to: 'products#index'
    get '/restaurants', to: 'restaurants#index'

    # Self written tests
    get '/orders', to: 'orders#index'
    get '/orders/:id', to: 'orders#courier'
    post '/orders', to: 'orders#create'

    get '/account/:id', to: 'accounts#index'
    post 'account/:id', to: 'accounts#update'

    post '/sms/send_message' => 'sms#send_message'
  end

end
