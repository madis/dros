Rails.application.routes.draw do
  resources :projects, only: [:index]
  get '/:owner/:repo', to: 'projects#show_slug', as: :project_slug

  root to: 'projects#index'
end
