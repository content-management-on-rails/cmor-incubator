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
  #            Cmor::TimeTracking::ProjectsController
  #          ]}
  #
  config.resources_controllers = -> {
    [
      Cmor::TimeTracking::IssuesController,
      Cmor::TimeTracking::ItemsController,
      Cmor::TimeTracking::ProjectsController
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
  #            Cmor::TimeTracking::UpdateIssueFromExternalServicesController
  #          ]}
  #
  config.service_controllers = -> {
    [
      Cmor::TimeTracking::UpdateIssueFromExternalServicesController
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
end
