Rails.application.routes.draw do

  # THE HOME CONTROLLER
  get "/home" => "home#index", as: :index
  get "/home/about" => "home#about", as: :about
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  # This will direct to the blog homepage
  root "home#index"


  # THE POSTS CONTROLLER
  resources :posts do
    resources :comments, only: [:index, :create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  resources :favorites, only: [:index]

  # THE USERS CONTROLLER
  resources :users, only: [:new, :create, :edit, :update, :show]
  get "/users/edit_password/:id" => "users#edit_password",  as: :edit_password
  patch "/users/edit_password/:id" => "users#update_password"

  # THE SESSIONS CONTROLLER
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
