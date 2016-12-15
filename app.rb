require 'sinatra'
require 'sinatra/json'
require File.dirname(__FILE__)+'/models/slides.rb'
$SLIDES_COUNT=18 # pecha kucha says 20 slides, which includes the intro and thank you slide
$rando_pk = Slides.new($SLIDES_COUNT)

get '/cache-images' do
  slides_list = $rando_pk.slides_image_list
  random_title = $rando_pk.generate_random_title
  puts "generating intro slide"
  $rando_pk.generate_slide(File.dirname(__FILE__)+"/public/img/slides/intro.png", random_title, File.dirname(__FILE__)+"/public/img/slides/slide_intro.png")
  until File.exist?(File.dirname(__FILE__)+"/public/img/slides/slide_intro.png")
    puts "Intro doesn't exist.. waiting"
    sleep 1
  end
  json "Cached all #{slides_list.size} images"
end

get '/' do
  @slides_list = $rando_pk.slides_image_list
  erb :index
end
