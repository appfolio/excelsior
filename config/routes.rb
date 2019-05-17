Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  resources :appreciations
  resources :feedbacks
  resources :users, only: [:show, :new, :create, :destroy]
  resources :faqs, only: [:index]
  resources :comments, only: [:create, :destroy]

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'appreciations#index'
end
