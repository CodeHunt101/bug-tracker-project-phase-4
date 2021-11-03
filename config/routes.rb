Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "welcome#home"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  resources :users, only: [:new, :create, :edit, :update, :index, :show] do
    resources :projects
  end

  # patch "/users/:id/projects/:id", to: "projects#update"
  # resources :projects
end
