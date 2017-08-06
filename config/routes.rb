Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  resources :pages do
    collection do 
      get :search
    end
  end
end
