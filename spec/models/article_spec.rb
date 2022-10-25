require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'has no Article to begin with' do
    expect(Article.count).to eq 0
  end

  it 'is not valid without URL' do
    expect(Article.new(title: 'Ruby inluence spreads')).to_not be_valid
  end

  it 'is not valid without title' do
    expect(Article.new(url: 'https://www.digitalocean.com/community/tutorials/ruby-influence-spreads')).to_not be_valid
  end

  it 'has one after adding one with valid data' do
    Article.create(url: 'https://www.digitalocean.com/community/tutorials/ruby-influence-spreads',
                   title: 'Ruby influence spreads')
    expect(Article.count).to eq 1
  end

  it 'has one article with two comments' do
    article = Article.create(url: 'https://www.digitalocean.com/community/tutorials/ruby-influence-spreads',
                   title: 'Ruby influence spreads')
    Comment.create(text: 'Ruby influence spreads', article_id: article.id)
    Comment.create(text: 'Ruby influence spreads', article_id: article.id)

    expect(article.comments.size).to eq 2
  end
end
