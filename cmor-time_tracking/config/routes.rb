Cmor::TimeTracking::Engine.routes.draw do
  resources :external_issues, only: [:index, :show] do
    get :autocomplete, on: :collection
  end

  resources :issues

  resources :items do
    post "trigger_event/:machine_name/:event_name", on: :member, action: "trigger_event", as: :trigger_event
  end

  resources :projects

  resource :update_issue_from_external_services, only: [:new, :create]

  root to: "home#index"
end
