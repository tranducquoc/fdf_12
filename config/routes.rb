Rails.application.routes.draw do

  namespace :domain do
    get "user_domains/new"
  end

  namespace :domain do
    get "domain_users/new"
  end

  namespace :domain do
    get "domains/new"
  end

  get "set_language/update"
  post "/rate" => "rater#create", :as => "rate"
  devise_for :admins, path: "admin",
    controllers: {sessions: "admin/sessions"}

  #devise_for :users, controllers: {
  #  omniauth_callbacks: "users/omniauth_callbacks",
  #  sessions: "users/sessions",
  #  registrations: "users/registrations"
  #}

  devise_for :users,
  controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }

  get "index" => "static_pages#index"
  get "canhan" => "static_pages#show"
  get "moble-page" => "static_pages#new"
  root "static_pages#home"
  mount ActionCable.server => "/cable"
  namespace :admin do
    root "home#index", path: "/"
    resources :orders, only: [:index, :show, :destroy]
    resources :shop_requests, only: [:index, :update]
    resources :categories
    resources :users
    resources :products, only: :index
    resources :set_user, only: :create
    resources :update_group_user, only: :create
    resources :shops, except: [:new, :create, :show]
    resources :request_shop_domains
    resources :domains, only: [:index, :show]
  end

  namespace :dashboard do
    root "statistics#index", path: "/"
    resources :shops do
      resources :products
      resources :orders
      resources :shop_managers, only: [:index, :create, :destroy, :update]
      resources :order_managers, only: [:index, :show]
      resources :order_products
      resources :accepted_order_products, defaults: {format: :json}
      resources :user_orders, only: [:index, :show]
      resources :group_orders, only: [:index, :show]
    end
    resources :statistics
    resources :new_manager_searches, only: :index
    resources :shop_manager_domains
    resources :shop_owners, only: :update
  end
  resources :domains do
    resources :products
    resources :shops
    resources :orders
    resources :carts
    resources :shop_domains
    resources :categories
  end
  resources :user_domains
  resources :shop_domains
  resources :order_fasts
  resources :user_settings, only: [:edit, :update]
  resources :shops, only: [:index, :show, :update]
  resources :products, only: [:index, :show, :new] do
    resources :comments, only: :create
  end
  resources :comments, only: :destroy
  resources :carts
  resources :orders
  resource :orders
  resources :users
  resources :events, only: [:index, :update] do
    post :read_all, on: :collection
  end
  resources :categories do
    resources :products
  end
  resources :tags, only: :show
  get "search(/:search)", to: "searches#index", as: :search
  resources :searches, only: :new

  resources :request_shop_domains
  resources :set_carts
  resources :pdf_readers, only: :index
  resources :user_searchs
  resources :user_domain_searches, only: :index
  resources :follow_shops, only: [:create, :destroy]

  api_version(module: "V1", path: {value: "v1"}, default: true) do
    namespace :dashboard do
      resources :shops, except: [:show, :destroy, :new], defaults: {format: :json}
      resources :order_managers, only: :index, defaults: {format: :json}
      resources :products, defaults: {format: :json}
      resources :orders, defaults: {format: :json}
      resources :order_products, only: [:update, :index], defaults: {format: :json}
      resources :shop_managers, only: :index, defaults: {format: :json}
      resources :shop_domains, only: :index, defaults: {format: :json}
    end
    resources :shops, only: [:index, :update], defaults: {format: :json}
    resources :list_members, defaults: {format: :json}
    resources :shop_domains, defaults: {format: :json}
    resources :orders_product_all, defaults: {format: :json}
    resources :domains, except: :new, defaults: {format: :json}
    resources :authen_user_tokens, only: :index, defaults: {format: :json}
    resources :products, only: :index, defaults: {format: :json}
    get "/logout", to: "users_logout#logout", defaults: {format: :json}
    resources :categories, only: :index, defaults: {format: :json}
    resources :orders, defaults: {format: :json}
    resources :shop_managers, defaults: {format: :json}
    resources :comments, defaults: {format: :json}
    resources :user_domains, defaults: {format: :json}
    resources :events, only: :index, defaults: {format: :json}
    resources :users, only: :update, defaults: {format: :json}
    resources :user_settings, only: :index, defaults: {format: :json}
    resources :searches, only: :index, defaults: {format: :json}
  end
end
