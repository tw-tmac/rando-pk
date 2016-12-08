require 'rest-client'
require 'json'
require 'open-uri'
$WIKIMEDIA_API_URL="https://commons.wikimedia.org/w/api.php"
$IMAGE_WIDTH=800
class Slides

  attr_accessor :slides_image_list
  attr_accessor :num_of_slides

  def initialize(num_of_slides=1)
    self.slides_image_list = []
    self.num_of_slides = num_of_slides
    get_images_from_wikimedia()
  end

  def slides_image_list
    @slides_image_list
  end

  def get_images_from_wikimedia
    rando_url = $WIKIMEDIA_API_URL+"?action=query&list=random&rnnamespace=6&rnlimit=#{@num_of_slides}&format=json&prop=imageinfo&iiprop=url&iiurlwidth=#{IMAGE_WIDTH}&format=json"
    rando_response = RestClient.get(rando_url)
    randomized_image_list = JSON.parse(rando_response)

    randomized_image_list["query"]["random"].each_with_index do |image, index|
      image_request_url = $WIKIMEDIA_API_URL+"?action=query&titles=#{CGI.escape(image["title"])}&prop=imageinfo&&iiprop=url&iiurlwidth=#{IMAGE_WIDTH}&format=json"
      image_response = RestClient.get(image_request_url)
      image_properties = JSON.parse(image_response)
      image_url = image_properties["query"]["pages"][image_properties["query"]["pages"].keys[0]]["imageinfo"][0]["thumburl"]
      @slides_image_list << image_url
    end
  end
end
