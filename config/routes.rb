Rails.application.routes.draw do
  resources :projects, only: [:index]

  root to: 'application#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
