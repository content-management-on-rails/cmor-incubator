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
sed -i "s|class User < ApplicationRecord|class User < ApplicationRecord\n  def human\n    email\n  end|g" app/models/user.rb

# Setup jira integration
cp ../../.env ./

# Setup Cmor::TimeTracking
rails generate cmor:time_tracking:install
rails cmor_time_tracking:install:migrations

# Setup database
rails db:migrate db:test:prepare

# Setup seeds
echo "Cmor::TimeTracking::Engine.load_seed" >> db/seeds.rb
rails db:seed
