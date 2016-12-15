require 'rest-client'
require 'json'
require 'open-uri'
require 'rmagick'
include Magick

class Slides

  attr_accessor :slides_image_list
  attr_accessor :num_of_slides
  MAX_HEIGHT=700

  HEADLINE_STYLES = [
    'FORCED_CULTURAL_REFERENCE',
    'YOURE_WRONG_ABOUT',
    'HYPE_HYPE_HYPE',
    'AND_WHY_IT_MATTERS'
  ]

 SHORT_PITHY_QUOTES = [
  'Survival is Success',
  'Go Big Or Go Home',
  'What If You Weren\'t Afraid?',
  'Fail Fast',
  'Success Is Built On Failure',
  'Risking Nothing Risks Everything',
  'Innovate Or Die',
  'If You Change Nothing, Nothing Will Change',
  'Don\'t Dream Of Success, Work For It',
  'Minimising Risk',
  'Collaborate Or Die',
  'Take Back Control',
  'Make It Great Again'
]

TRENDY_CULTURAL_REFERENCES = [
  'Brexit',
  'The EU Referendum',
  'The Presidential Election',
  'The US Election',
  'Donald Trump',
  'Hilary Clinton',
  'Teresa May',
  'The Loss of Marmite',
  'Blockchain Technology',
  'Game Of Thrones',
  'Justin Bieber',
  'Taylor Swift',
  'Kanye West',
  'Kim Kardashian',
  '"Bremoaners"',
  'Gears of War'
]

BUSINESS_BUZZ_WORDS = [
  'Entrepreneurship',
  'Innovation',
  'Leadership',
  'Startups',
  'Industry Disruption',
  'Lean Startup',
  'Agile Software Development',
  'Digital Transformation',
  'User Centric Design',
  'The Web Platform'
]

CONTENTIOUS_THEMES = [
  'The Death of Twitter',
  'The Robot Apocalypse',
  'Google\'s Tax Policy',
  'Silicon Valley Excess',
  'Internet Privacy',
  'Remote Working',
  'The Internet of Things',
  'Self-Driving Cars',
  'Web vs Native'
]

  def initialize(num_of_slides=1)
    self.slides_image_list = []
    self.num_of_slides = num_of_slides
    get_images_from_wikimedia()
  end

  def slides_image_list
    @slides_image_list[1..@num_of_slides]
  end

  def get_images_from_wikimedia
    rando_url = "https://commons.wikimedia.org/w/api.php?action=query&list=random&rnnamespace=6&rnlimit=45&format=json&prop=imageinfo&iiprop=url&iiurlwidth=800&format=json"
    rando_response = RestClient.get(rando_url)
    randomized_image_list = JSON.parse(rando_response)

    randomized_image_list["query"]["random"].each_with_index do |image, index|
      image_request_url = "https://commons.wikimedia.org/w/api.php?action=query&titles=#{CGI.escape(image["title"])}&prop=imageinfo&&iiprop=url&iiurlwidth=800&format=json"
      image_response = RestClient.get(image_request_url)
      image_properties = JSON.parse(image_response)
      if (image_properties["query"]["pages"][image_properties["query"]["pages"].keys[0]]["imageinfo"][0]["thumbheight"] > MAX_HEIGHT)
        next
      end
      image_url = image_properties["query"]["pages"][image_properties["query"]["pages"].keys[0]]["imageinfo"][0]["thumburl"]
      if (image_url.downcase.include?("png") || image_url.downcase.include?("jpg") || !image_url.downcase.include?("icon"))
        @slides_image_list << image_url
      end
    end
  end

#adapted from: https://github.com/poshaughnessy/medium-headline-generator/blob/master/src/js/headlineGenerator.js
  def generate_random_title
    headline_style = HEADLINE_STYLES.sample
    short_pithy_quote = SHORT_PITHY_QUOTES.sample
    trendy_cultural_reference = TRENDY_CULTURAL_REFERENCES.sample
    business_buzz_word = BUSINESS_BUZZ_WORDS.sample
    contentious_theme = CONTENTIOUS_THEMES.sample
    case (headline_style)
      when 'FORCED_CULTURAL_REFERENCE'
        "#{short_pithy_quote}: What #{trendy_cultural_reference} Teaches Us About #{business_buzz_word}"
      when 'YOURE_WRONG_ABOUT'
        "Why #{trendy_cultural_reference} Shows You're Wrong About #{contentious_theme}"
      when 'HYPE_HYPE_HYPE'
        "#{rand(20)} Ways That #{trendy_cultural_reference} Is Going To Change #{business_buzz_word}"
      end
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
end
