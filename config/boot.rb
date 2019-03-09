ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require File.expand_path('../initializers/debug_require', __FILE__)
require 'bundler/setup' # Set up gems listed in the Gemfile.


