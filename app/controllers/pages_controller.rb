class PagesController < ApplicationController
  def home; end

  def get
    response = CapybaraServices::Parser.parse_digital_ocean_article('https://www.digitalocean.com/community/tutorials/react-tabs-component')
    puts response
  end
end
