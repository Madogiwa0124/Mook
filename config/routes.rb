Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  devise_scope :user do
    root :to => "devise/sessions#new"
  end
  resources :pages do
    collection do 
      get :search
      get :all_read
    end
    member do 
      get :read
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
  end
  resources :favorites, only: [:create, :destroy]
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
