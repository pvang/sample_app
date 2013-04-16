source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'bootstrap-sass', '~> 2.1' # gem to add Bootstrap framework for visual formatting purposes
gem 'bcrypt-ruby', '~> 3.0.1' # gem to add bcrypt (irreversibly encrypt passwords to form the password hash)
gem 'faker', '~> 1.0.1' # faker gem (allows us to make sample users with semi-realistic names and email addresses)
gem 'will_paginate', '~> 3.0.3' # the simplest and most robust pagination method in Rails
gem 'bootstrap-will_paginate', '~> 0.0.6' # configures will_paginate to use Bootstrap’s pagination styles

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '~> 2.11.0' # gem to RSpec (alternative to the default testing framework)
  gem 'annotate', '~> 2.5.0' # this adds comments containing data model to model file app/models
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.2.3'
end

gem 'jquery-rails', '~> 2.0.2'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test do
  gem 'capybara', '~> 1.1.2' # this gem will allow us to simulate a user's interaction using natural english-like syntax
  gem 'factory_girl_rails', '~> 4.1.0' # a more convenient way to define user objects and insert them into databases

  gem 'cucumber-rails', '~> 1.2.1', :require => false # cucumber-rails gem (used for writing signin tests, a popular tool for behavior-driven development)
  gem 'database_cleaner', '~> 0.7.0' # utility gem
end

group :production do
  gem 'pg', '~> 0.12.2' # heroku deployment purposes
end

gem 'rb-readline' # rails console purposes