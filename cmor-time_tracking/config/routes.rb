Cmor::TimeTracking::Engine.routes.draw do
  resources :external_issues, only: [:index, :show] do
    get :autocomplete, on: :collection
  end

  resources :issues

  resources :items do
    post "trigger_event/:machine_name/:event_name", on: :member, action: "trigger_event", as: :trigger_event
    post :destroy_many, on: :collection
  end

  resources :projects
  resources :project_rates
  resources :rates

  resource :update_issue_from_external_services, only: [:new, :create]

  resource :billing_run_services, only: [:new, :create]

  root to: "home#index"
end
