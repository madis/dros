Rails.application.routes.draw do
  resources :projects, only: [:index]
  get '/:owner/:repo', to: 'projects#slug'

  root to: 'application#welcome'
end
