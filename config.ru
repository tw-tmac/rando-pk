require 'sinatra'
require File.dirname(__FILE__) + '/app'
use Rack::MethodOverride
run Sinatra::Application
$stdout.sync = true
