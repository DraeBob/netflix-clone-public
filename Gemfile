source 'https://rubygems.org'

gem 'rails', '3.2.11'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bcrypt-ruby'
gem 'bootstrap_form'
gem 'resque'
gem 'sidekiq'
gem 'unicorn'
gem "rest-client"
gem 'figaro'
gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem "mini_magick"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'draper', '~> 1.0'
gem 'stripe_event'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'pry-nav'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :production do
  gem 'pg'
end

gem 'jquery-rails'


group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock', '1.11.0'
  gem 'selenium-webdriver'
end

group :development, :test do
  gem "shoulda-matchers"
  gem 'faker'
  gem 'fabrication'
  gem 'pry'
  gem 'rspec-rails', '~> 2.0'
  gem 'launchy'
  gem 'database_cleaner'
end
