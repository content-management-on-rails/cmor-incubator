#!/bin/bash

# Delete old dummy app
rm -rf spec/dummy

# Generate new dummy app
# DISABLE_MIGRATE=true bundle exec rake dummy:app
DISABLE_MIGRATE=true bundle exec ruby -e 'require "rails/dummy/generator"; params = %w(-f ./spec/dummy -n DummyApp -G -j importmap -a propshaft -T); Rails::Dummy::Generator.start(params)'

if [ ! -d "spec/dummy/config" ]; then exit 1; fi

# Cleanup
rm spec/dummy/.ruby-version
rm spec/dummy/Gemfile

cd spec/dummy

# Use correct Gemfile
gsed -i "s|../Gemfile|../../../Gemfile|g" config/boot.rb

# Temporarily make sprockets/webpcker happy
mkdir -p app/assets/config
touch app/assets/config/manifest.js
rails webpacker:install

# Setup js
rails importmap:install turbo:install stimulus:install

# Setup css
rails css:install:sass

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

# Setup dummy app
rails g model User email:string
gsed -i "/end/i\  def current_frontend_auth_user; end" app/controllers/application_controller.rb

# Setup bootstrap
bin/importmap pin bootstrap
yarn add bootstrap
# add import to app/assets/stylesheets/application.sass.scss
echo '@import "bootstrap/scss/bootstrap";' >> app/assets/stylesheets/application.sass.scss

# Setup chart.js
echo "pin 'chart.js', to: 'https://ga.jspm.io/npm:chart.js@4.2.0/dist/chart.js'" >> config/importmap.rb
echo "pin '@kurkle/color', to: 'https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js'" >> config/importmap.rb

echo "import { Chart, registerables } from 'chart.js'" >> app/javascript/application.js
echo "Chart.register(...registerables)" >> app/javascript/application.js
echo "window.Chart = Chart" >> app/javascript/application.js

# Application layout
tee app/views/layouts/application.html.erb > /dev/null <<EOT
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Dummy</title>

    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag    "application", media: "all" %>
    <%= javascript_importmap_tags %>
    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  </head>
  <body>
    <% flash.each do |type, msg| %>
      <div>
        <%= msg %>
      </div>
    <% end %>
    <%= yield %>
  </body>
</html>
EOT

# Setup unpermitted params
gsed -i '/end/i\  config.action_controller.action_on_unpermitted_parameters = :raise' config/environments/test.rb

# Setup jira integration
cp ../../.env ./

# Setup Bgit::Invoicing
rails generate bgit:invoicing:install
rails bgit_invoicing:install:migrations

# Setup Cmor::TimeTracking
rails generate cmor:time_tracking:install
rails cmor_time_tracking:install:migrations

# Setup Cmor::TimeTracking::Frontend
rails generate cmor:time_tracking:frontend:install

# Setup database
rails db:migrate db:test:prepare

# Setup seeds
echo "Cmor::TimeTracking::Engine.load_seed" >> db/seeds.rb
rails db:seed
