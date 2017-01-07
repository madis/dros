Rails.application.routes.draw do
  resources :projects, only: [:index]
  get '/:owner/:repo', to: 'projects#slug', as: :article_slug

  root to: 'projects#index'
end
