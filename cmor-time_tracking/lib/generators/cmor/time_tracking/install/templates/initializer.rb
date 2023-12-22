Cmor::TimeTracking.configure do |config|
  # Register self to be shown in the backend.
  #
  # Default: config.register_engine("Cmor::TimeTracking::Engine", {})
  #
  config.cmor.administrador.register_engine("Cmor::TimeTracking::Engine", {})

  # Set the resources, that will be shown in the backend menu.
  #
  # Default: config.resources_controllers = -> {[
  #            Cmor::TimeTracking::IssuesController,
  #            Cmor::TimeTracking::ItemsController,
  #            Cmor::TimeTracking::ProjectsController,
  #            Cmor::TimeTracking::RatesController,
  #            Cmor::TimeTracking::ProjectRatesController
  #          ]}
  #
  config.resources_controllers = -> {
    [
      Cmor::TimeTracking::IssuesController,
      Cmor::TimeTracking::ItemsController,
      Cmor::TimeTracking::ProjectsController,
      Cmor::TimeTracking::RatesController,
      Cmor::TimeTracking::ProjectRatesController
    ]
  }

  # Set the singular resources, that will be shown in the backend menu.
  #
  # Default: config.resource_controllers = -> {[
  #          ]}
  #
  config.resource_controllers = -> {
    []
  }

  # Set the services, that will be shown in the backend menu.
  #
  # Default: config.service_controllers = -> {[
  #            Cmor::TimeTracking::BillingRunServicesController,
  #            Cmor::TimeTracking::UpdateIssueFromExternalServicesController
  #          ]}
  #
  config.service_controllers = -> {
    [
      Cmor::TimeTracking::BillingRunServicesController,
      Cmor::TimeTracking::UpdateIssueFromExternalServicesController,
    ]
  }

  # Set the sidebars, that will be shown in the backend menu.
  #
  # Default: config.sidebar_controllers = -> {[
  #          ]}
  #
  config.sidebar_controllers = -> {
    []
  }

  # Set the item owner class.
  #
  # Default: config.item_owner_class = -> { <%= @item_owner_class_name %> }
  #
  config.item_owner_class = -> { <%= @item_owner_class_name %> }
  
  # Set the item owner factory name.
  #
  # Default: config.item_owner_factory_name = -> { :<%= @item_owner_factory_name %> }
  #
  config.item_owner_factory_name = -> { :<%= @item_owner_factory_name %> }

  # Set the project owner factory name.
  #
  # Default: config.project_owner_factory_name = -> { :<%= @project_owner_factory_name %> }
  #
  config.project_owner_factory_name = -> { :<%= @project_owner_factory_name %> }

  # Set the project and invoice owner classes and options.
  #
  # Default: config.project_owner_classes = lambda do
  #            {
  #              User => main_app.url_for([:autocomplete, User])
  #            }
  #          end
  #
  config.project_owner_classes = lambda do
    {
      User => main_app.url_for([:autocomplete, User])
    }
  end

  # Set the default project owner.
  #
  # Default: config.default_project_owner = -> { User.first_or_create!(email: "jane.doe@domain.local") }
  #
  config.default_project_owner = -> { User.first_or_create!(email: "jane.doe@domain.local") }

  # Set the default currency.
  #
  # Default: config.default_currency = -> { "EUR" }
  #
  config.default_currency = -> { "EUR" }
end
