require 'sinatra'
require 'sinatra/json'
require File.dirname(__FILE__)+'/models/slides.rb'
$SLIDES_COUNT=18 # pecha kucha says 20 slides, which includes the intro and thank you slide
$rando_pk = Slides.new($SLIDES_COUNT)

get '/cache-images' do
  slides_list = $rando_pk.slides_image_list
  $rando_pk.generate_intro_slide
  json "Cached all #{slides_list.size} images"
end

get '/' do
  @slides_list = $rando_pk.slides_image_list
  erb :index
end
