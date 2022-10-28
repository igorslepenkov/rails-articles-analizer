require 'rails_helper'

RSpec.describe MonkeyLearnServices::SentimentAnalizer do
  it 'should return array of analyzed_comments' do
    comments = ['This is a great tool', 'This is awful!!!'] 
    response = MonkeyLearnServices::SentimentAnalizer.call(comments)

    expect(response.class).to eq Array
  end

  it 'should return array of the same size, that one, which was provided' do
    comments = ['This is a great tool', 'This is awful!!!']
    response = MonkeyLearnServices::SentimentAnalizer.call(comments)

    expect(response.size).to eq comments.size
  end

  it 'should contain analized_articles with "text" and "classifications"' do
    comments = ['This is a great tool', 'This is awful!!!']
    response = MonkeyLearnServices::SentimentAnalizer.call(comments)

    expect(response.first['text']).to_not be(nil)
    expect(response.first['classifications']).to_not be(nil)
  end
end