class PagesController < ApplicationController
  def home; end

  def get
    response = CapybaraServices::Parser.parse_article('https://medium.com/yardcouch-com/youtube-is-dead-and-something-new-is-coming-132322b09be6')
    puts response
  end
end
