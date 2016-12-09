ENV['RACK_ENV'] = 'test'

require File.expand_path('../app', File.dirname(__FILE__))
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.include Rack::Test::Methods
end
