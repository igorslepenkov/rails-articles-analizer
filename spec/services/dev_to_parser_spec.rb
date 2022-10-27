require 'rails_helper'

RSpec.describe CapybaraServices::DevToParser do
  it 'should return hash with :title and :comments for valid links' do
    hash = CapybaraServices::DevToParser.call('https://dev.to/coorasse/rails-7-bootstrap-5-and-importmaps-without-nodejs-4g8')
    expect(hash).to include(:title, :comments)
  end

  it 'should return empty hash with empty :title and empty :comments if link is invalid' do
    hash = CapybaraServices::DevToParser.call('')
    expect(hash).to include(title: '', comments: [])
  end
end