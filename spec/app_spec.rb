require 'spec_helper'

describe 'RandoPK App' do

  def app
    Sinatra::Application
  end

  it "caches images" do
    get '/cache-images'
    expect(last_response).to be_ok
    expect(last_response.body).to include('18 images')
  end
end
