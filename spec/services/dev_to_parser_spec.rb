require 'rails_helper'

RSpec.describe CapybaraServices::DevToParser do
  it 'should return hash with :title and :comments for valid links' do
    hash = CapybaraServices::DevToParser.call('https://dev.to/coorasse/rails-7-bootstrap-5-and-importmaps-without-nodejs-4g8')
    expect(hash).to include(:title, :comments)
  end

  it 'should return hash with empty :title and empty :comments if link is invalid' do
    hash = CapybaraServices::DevToParser.call('')
    expect(hash).to include(title: '', comments: [])
  end

  it 'should return hash with empty :title and empty :comments if link is valid, but unexpected error occured' do

    ## Next link doesn't supported by our service, so it will cause an error, but our changes have to work
    hash = CapybaraServices::DevToParser.call('https://medium.com/@james.a.hughes/using-the-reduce-method-in-ruby-907f3c18ae1f')
    expect(hash).to include(title: '', comments: [])
  end
end