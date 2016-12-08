require 'sinatra'
require 'sinatra/json'
require File.dirname(__FILE__)+'/models/slides.rb'

$SLIDES_COUNT=10

get '/cache-images' do
  @rando_pk = Slides.new($SLIDES_COUNT)
  @slides_list = @rando_pk.slides_image_list

  @slides_list.each_with_index do |slide, index|
    open("public/img/slides/slide_#{index}.png", 'wb') do |file|
      file << open(slide).read
    end
  end
  json "Cached all #{@slides_list.size} images"
end

get '/' do
  erb :index
end
