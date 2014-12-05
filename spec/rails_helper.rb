ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

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
end
