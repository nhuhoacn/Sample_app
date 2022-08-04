Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "users/new"
    root "static_pages#home"
    get "static_pages/home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, except: :destroy
    resources :users
    resources :account_activations, only: %i(edit create)
    resources :password_resets, except: %i(destroy index show)
    resources :microposts, only: %i(create destroy)
  end
end
