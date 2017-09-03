Rails.application.routes.draw do
  devise_for :users
  root 'pages#index'
  resources :pages do
    collection do 
      get :search
    end
    member do 
      get :read
    end
  end
  resources :favorites
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
