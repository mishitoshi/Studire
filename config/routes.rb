Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'home/index'

  root to: "home#index"

  # devise
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  } 
  get '/users', to: redirect("/users/sign_up")
  
  devise_scope :user do
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy" 
  end

  resources :users, only: [:show] do
    member do
      get :likes
    end
  end
  resources :posts do
    # コメント機能　destroy追加予定
    resources :comments, only: [:create, :destroy]
  end
  # フォロー機能
  resources :relationships, only: [:create, :destroy]
  # お気に入り
  resources :favorites, only: [:create, :destroy]
  get 'tags/:tag', to: 'home#index', as: :tag
  get 'likes/tags/:tag', to: 'users#likes', as: :likes_tag
end
