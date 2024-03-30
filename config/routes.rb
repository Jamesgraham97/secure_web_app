# config/routes.rb

Rails.application.routes.draw do
  resources :users do
    collection do
      get 'login'
      post 'authenticate'
      get 'logout'  # Add a logout route
    end
  end

  resources :messages

  root 'users#login'  # Set the login page as the root
end
