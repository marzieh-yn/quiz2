# Rails.application.routes.draw do
#   get 'reviews/new'
#   get 'reviews/create'
#   get 'welcome/new'
#   get 'welcome/create'
#   get 'users/new'
#   get 'users/create'
#   get 'sessions/new'
#   get 'sessions/create'
#   get 'ideas/new'
#   get 'ideas/create'
#   get 'likes/new'
#   get 'likes/create'
#   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
# end
Rails.application.routes.draw do
 
  root 'welcome#home'
  
  get('/home', to: 'welcome#home')
  match '/signup',  to: 'users#new',            via: 'get'
  match '/logout',  to: 'sessions#destroy',            via: 'get'

  # Session Routes
  resource :session, only: [:new, :create, :destroy]

 
  resources :ideas do
    resources :reviews, shallow: :true, only: [:create, :destroy] do
      resources :likes, only: [:create, :destroy]
    end
  end

  resources :news_articles

  resources :users, only: [:new, :create]
end
