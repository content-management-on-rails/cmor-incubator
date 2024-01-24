Cmor::TimeTracking::Frontend::Engine.routes.draw do
  localized do
    scope :cmor_time_tracking_frontend_engine do
      resources :projects, only: [:index, :show]
    end
  end
end
