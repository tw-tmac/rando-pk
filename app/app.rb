require 'sinatra'
require 'sinatra/json'
require File.dirname(__FILE__)+'/models/slides.rb'
$SLIDES_COUNT=10
$rando_pk = Slides.new($SLIDES_COUNT)
get '/cache-images' do
  slides_list = $rando_pk.slides_image_list
  slides_list.each_with_index do |slide, index|
    open(File.dirname(__FILE__)+"/public/img/slides/slide_#{index}.png", 'wb') do |file|
      file << open(slide).read
    end
  end
  $rando_pk.generate_intro_slide
  $rando_pk.generate_thankyou_slide
  json "Cached all #{slides_list.size} images"
end

get '/' do
  @slides_list = $rando_pk.slides_image_list
  erb :index
end
