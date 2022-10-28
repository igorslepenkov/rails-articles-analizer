require 'rails_helper'

RSpec.describe CapybaraServices::DigitalOceanParser do
  it 'should return hash with :title and :comments for valid links' do
    hash = CapybaraServices::DigitalOceanParser.call('https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes')
    expect(hash).to include(:title, :comments)
  end

  it 'should return hash with empty :title and empty :comments if link is invalid' do
    hash = CapybaraServices::DigitalOceanParser.call('')
    expect(hash).to include(title: '', comments: [])
  end

  it 'should return hash with empty :title and empty :comments if link is valid, but unexpected error occured' do

    ## Next link doesn't supported by our service, so it will cause an error, but our changes have to work
    hash = CapybaraServices::DigitalOceanParser.call('https://medium.com/@james.a.hughes/using-the-reduce-method-in-ruby-907f3c18ae1f')
    expect(hash).to include(title: '', comments: [])
  end
end