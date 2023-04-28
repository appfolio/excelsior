# frozen_string_literal: true

if ENV.key?('RECORD_DEPRECATIONS')
  require 'deprecation_toolkit'
  DeprecationToolkit::Configuration.deprecation_path = 'deprecations'
  DeprecationToolkit::Configuration.behavior = DeprecationToolkit::Behaviors::Record

  # Enable ruby deprecations for keywords, it's suppressed by default in Ruby 2.7.2
  Warning[:deprecated] = true

  kwargs_warnings = [
    # Taken from https://github.com/jeremyevans/ruby-warning/blob/1.3.0/lib/warning.rb#L18
    # rubocop:disable Layout/LineLength
    /: warning: (?:Using the last argument (?:for `.+' )?as keyword parameters is deprecated; maybe \*\* should be added to the call|Passing the keyword argument (?:for `.+' )?as the last hash parameter is deprecated|Splitting the last argument (?:for `.+' )?into positional and keyword parameters is deprecated|The called method (?:`.+' )?is defined here)\n\z/
    # rubocop:enable Layout/LineLength
  ]
  DeprecationToolkit::Configuration.warnings_treated_as_deprecation = kwargs_warnings
end
