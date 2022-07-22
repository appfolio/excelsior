def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source 'https://rubygems.org'

ruby '2.5.8'
gem 'rails', '5.2.8.1'

gem 'pg', '~> 0'
gem 'devise', '4.6.2'
gem 'omniauth-google-oauth2', '0.6.0'

gem 'rails_12factor', '0.0.3', group: :production
gem 'puma', '~> 3'
gem 'jquery-rails', '4.2.2'

gem 'bootstrap-sass', '~> 3.3.4'
gem 'sass-rails', '5.0.7'

gem 'uglifier', '2.7.2'
gem 'hideable', '0.3.1'
gem 'httparty', '0.13.7'
gem 'will_paginate', '>= 3.1.7', '< 4'

group :development do
  gem 'annotate', '~> 2.7.4'
  gem 'listen'
  gem 'next_rails'
end

group :development, :test do
  gem 'factory_bot_rails', '~> 5'
  gem 'pry', '~> 0'
  gem 'pry-remote', '~> 0'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  gem 'mocha', '~> 1'
  gem 'pronto'
  gem 'pronto-rubocop', require: false
  gem 'pronto-undercover', github: 'grodowski/pronto-undercover'
  gem 'rails-controller-testing'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'undercover'
  gem 'webmock', '~> 1'
end
