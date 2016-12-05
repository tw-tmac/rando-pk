require 'sinatra'
require 'sinatra/json'
require 'rest-client'
require 'json'
require 'open-uri'

SLIDES_COUNT=10
rando_url = "https://commons.wikimedia.org/w/api.php?action=query&list=random&rnnamespace=6&rnlimit=#{SLIDES_COUNT}&format=json&prop=imageinfo&iiprop=url&iiurlwidth=800&format=json"

get '/cache-images' do
  rando_response = RestClient.get(rando_url)
  randomized_image_list = JSON.parse(rando_response)

  randomized_image_list["query"]["random"].each_with_index do |image, index|
    image_request_url = "https://commons.wikimedia.org/w/api.php?action=query&titles=#{CGI.escape(image["title"])}&prop=imageinfo&&iiprop=url&iiurlwidth=800&format=json"
    json image_request_url
    image_response = RestClient.get(image_request_url)
    image_properties = JSON.parse(image_response)
    image_url = image_properties["query"]["pages"][image_properties["query"]["pages"].keys[0]]["imageinfo"][0]["thumburl"]
    open("public/img/slides/slide_#{index}.png", 'wb') do |file|
      file << open(image_url).read
    end
  end
  json "done"
end

get '/' do
  erb :index
end
