Rails.application.routes.draw do
  root to: "public/homes#top"
  namespace :admin do
    resources :users, only:[:index,:show,:edit,:update]
    resources :posts, only:[:index,:show,:edit,:update,:destroy]
    resources :comments, only:[:index,:show,:destroy]
    root to: 'homes#top'
  end

  scope module: :public do
    get 'liked_post', to: 'favorites#liked_post'
    resources :posts, only: [:new, :index, :show, :edit, :create, :update, :destroy] do
      resources :comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end
    get 'users/my_page', to: 'users#show' ,as: :my_page
    get 'users/information/edit', to: 'users#edit', as: :users_edit
    patch 'users/information', to: 'users#update'
    patch 'users/quit', to: 'users#quit'
    get 'users/withdrawal'
    get "/about" => "homes#about", as: "about"
    get "search" => "searches#search"
  end

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
