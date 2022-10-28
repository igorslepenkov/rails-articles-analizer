require 'rails_helper'
require 'webmock/rspec'

RSpec.describe MonkeyLearnServices::SentimentAnalizer do
  context 'when analizer returns values' do
    before do
      request = [
        {
          "status_code": 200,
          "text": 'This is a great tool!',
          "error": false,
          "classifications": [
            {
              "tag_name": 'Positive',
              "tag_id": 33_767_179,
              "confidence": 0.998
            }
          ]
        },
        {
          "text": 'This is a great tool!',
          "error": false,
          "classifications": [
            {
              "tag_name": 'Positive',
              "tag_id": 33_767_179,
              "confidence": 0.998
            }
          ]
        }
      ]
      WebMock.stub_request(:post, 'https://api.monkeylearn.com/v3/classifiers/cl_pi3C7JiL/classify/')
             .with(headers: { 'Authorization': "Token #{ENV['MONKEY_KEY']}", 'Content-Type': 'application/json' })
             .to_return(status: 200, body: request.to_json, headers: {})
    end

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

  context 'when analizer returns hash with status code 429 (error)' do
    before do
      WebMock.stub_request(:post, 'https://api.monkeylearn.com/v3/classifiers/cl_pi3C7JiL/classify/')
             .with(headers: { 'Authorization': "Token #{ENV['MONKEY_KEY']}", 'Content-Type': 'application/json' })
             .to_return(status: 200, body: { "status_code": 429 }.to_json, headers: {})
    end
    it 'should raise SentimentAnalizerReturnedAnError' do
      comments = ['This is a great tool', 'This is awful!!!']
      expect do
        MonkeyLearnServices::SentimentAnalizer.call(comments)
      end.to raise_error(NewslizerExceptions::SentimentAnalizerReturnedAnError)
    end
  end
end
