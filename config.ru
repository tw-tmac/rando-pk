require 'sinatra'
require File.expand_path 'app.rb', __FILE__
use Rack::MethodOverride
run Sinatra::Application
