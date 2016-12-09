require 'rest-client'
require 'json'
require 'open-uri'
require 'rmagick'
include Magick

class Slides

  attr_accessor :slides_image_list
  attr_accessor :num_of_slides

  def initialize(num_of_slides=1)
    self.slides_image_list = []
    self.num_of_slides = num_of_slides
    get_images_from_wikimedia()
  end

  def slides_image_list
    @slides_image_list[1..@num_of_slides]
  end

  def get_images_from_wikimedia
    rando_url = "https://commons.wikimedia.org/w/api.php?action=query&list=random&rnnamespace=6&rnlimit=30&format=json&prop=imageinfo&iiprop=url&iiurlwidth=800&format=json"
    rando_response = RestClient.get(rando_url)
    randomized_image_list = JSON.parse(rando_response)

    randomized_image_list["query"]["random"].each_with_index do |image, index|
      image_request_url = "https://commons.wikimedia.org/w/api.php?action=query&titles=#{CGI.escape(image["title"])}&prop=imageinfo&&iiprop=url&iiurlwidth=800&format=json"
      image_response = RestClient.get(image_request_url)
      image_properties = JSON.parse(image_response)
      image_url = image_properties["query"]["pages"][image_properties["query"]["pages"].keys[0]]["imageinfo"][0]["thumburl"]
      if (image_url.downcase.include?("png") || image_url.downcase.include?("jpg"))
        @slides_image_list << image_url
      end
    end
  end

  def generate_random_title
    word_1 = ["Breaking","The Politics of","Fantastic","Decadent","Queering","Collective","Romancing","Mediating","An Overwhelming","Arbitrary","Remixing","For Love of","Alchemical","Apposite","Extravagant","Parsing","Relational","Postcolonial","To Find the Properties of","Archaeological","After the","In Search of","Whither","The Bureaucracies of"]
    word_2 = ["Ground","Dissent","Illusion","Rubbish","Dreams","Imagination","Gaming","Media","Banality","Charm","History","Chemistry","Properties","Relevance","Extravaganza","Dilettantes","(Im)Possibilities","Sustainability"]
    word_3 = ["Cheating","The Politics of","The Video Art of","Queers and","Daring to Defy","A Juried Show of","Media Art and","A Retrospective of","15 Years of","Defying","John Waters and","Locality and","A Remix of","Figuring","The Disjunction of","The Dysfunction of","Post-Painterly Art of","Achieving and Undermining","Constructing a Praxis of","Deconstructing"]
    word_4 = ["the System","Social Practice","Gender","the Status Quo","Complacency","Remediation","Misfortune","Damage","Sameness","Interactivity","Change","the Local","Urban Experience","the Avant Garde","Dilettantism","Juncture","Dysfunction","Progress","Too Many Dinner wordies","Aesthetic Forms and Their Opposites"]
    "#{word_1.sample} #{word_2.sample}: #{word_3.sample} #{word_4.sample}"
  end

  def generate_slide(original_image, caption, slide_name)
    img = ImageList.new(original_image)
    img <<  Magick::Image.read("caption:#{caption}") {
      self.fill = '#FFFFFF'
      self.gravity = Magick::CenterGravity
      self.font = "Helvetica"
      self.pointsize = 32
      self.size = "800x600"
      self.background_color = "none"
    }.first

    slide = img.flatten_images
    slide.write(slide_name)
  end

  def generate_intro_slide
    puts "generating intro slide"
    generate_slide(File.dirname(__FILE__)+"/../public/img/slides/intro.png", generate_random_title, File.dirname(__FILE__)+"/../public/img/slides/slide_intro.png")
  end

end
