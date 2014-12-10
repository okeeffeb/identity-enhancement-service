ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

ActiveRecord::Migration.maintain_test_schema!

module ControllerMatchers
  extend RSpec::Matchers::DSL

  matcher :have_assigned do |sym, obj|
    match { assigns[sym] == obj }
    description { "have assigned the #{sym}" }
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include ControllerMatchers, type: :controller

  config.around(:example, :debug) do |example|
    old = ActiveRecord::Base.logger
    begin
      ActiveRecord::Base.logger = Logger.new($stderr)
      example.run
    ensure
      ActiveRecord::Base.logger = old
    end
  end
end
