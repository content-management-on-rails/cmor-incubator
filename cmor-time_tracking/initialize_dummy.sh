#!/bin/bash

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
DISABLE_MIGRATE=true bundle exec rake dummy:app

if [ ! -d "spec/dummy/config" ]; then exit 1; fi

# Cleanup
rm spec/dummy/.ruby-version
rm spec/dummy/Gemfile

cd spec/dummy

# Use correct Gemfile
sed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Setup Webpacker
rails webpacker:install

# Setup ActiveStorage
rails active_storage:install

# Setup SimpleForm
rails generate simple_form:install --bootstrap

# Setup i18n
touch config/initializers/i18n.rb
echo "Rails.application.config.i18n.available_locales = [:en, :de]" >> config/initializers/i18n.rb
echo "Rails.application.config.i18n.default_locale    = :de" >> config/initializers/i18n.rb

# Setup i18n routing
touch config/initializers/route_translator.rb
echo "RouteTranslator.config do |config|" >> config/initializers/route_translator.rb
echo "  config.force_locale = true" >> config/initializers/route_translator.rb
echo "end" >> config/initializers/route_translator.rb

# Setup Administrador
rails generate administrador:install

# Setup Cmor::Core
rails generate cmor:core:install

# Setup Cmor::Core::Backend
rails generate cmor:core:backend:install

# Setup Cmor::Core::Settings
rails generate cmor:core:settings:install
rails cmor_core_settings:install:migrations

# Setup owner model
rails g model User email:string
sed -i "2i\  include SimpleFormPolymorphicAssociations::Model::AutocompleteConcern" app/models/user.rb
sed -i "3i\  autocomplete scope: ->(matcher) { where(\"users.email LIKE :term\", term: \"%#{matcher.downcase}%\") }, id_method: :id, text_method: :email" app/models/user.rb
sed -i "3i\  def human; email; end" app/models/user.rb

# Setup user autocomplete endpoint
touch app/controllers/users_controller.rb
echo "class UsersController < Cmor::Core::Backend::ResourcesController::Base" >> app/controllers/users_controller.rb
echo "  include SimpleFormPolymorphicAssociations::Controller::AutocompleteConcern" >> app/controllers/users_controller.rb
echo "" >> app/controllers/users_controller.rb
echo "  def self.resource_class" >> app/controllers/users_controller.rb
echo "    User" >> app/controllers/users_controller.rb
echo "  end" >> app/controllers/users_controller.rb
echo "" >> app/controllers/users_controller.rb
echo "  private" >> app/controllers/users_controller.rb
echo "" >> app/controllers/users_controller.rb
echo "  def permitted_params" >> app/controllers/users_controller.rb
echo "    params.require(:user).permit()" >> app/controllers/users_controller.rb
echo "  end" >> app/controllers/users_controller.rb
echo "end" >> app/controllers/users_controller.rb
echo "" >> app/controllers/users_controller.rb

sed -i "2i\  resources :users do" config/routes.rb
sed -i "3i\    get :autocomplete, on: :collection" config/routes.rb
sed -i "4i\  end" config/routes.rb

# Setup unpermitted params
sed -i '/end/i\  config.action_controller.action_on_unpermitted_parameters = :raise' config/environments/test.rb

# Setup jira integration
cp ../../.env ./

# Setup Bgit::Invoicing
rails generate bgit:invoicing:install
rails bgit_invoicing:install:migrations

# Setup Cmor::TimeTracking
rails generate cmor:time_tracking:install
rails cmor_time_tracking:install:migrations

# Setup database
rails db:migrate db:test:prepare

# Setup seeds
echo "Cmor::TimeTracking::Engine.load_seed" >> db/seeds.rb
rails db:seed
