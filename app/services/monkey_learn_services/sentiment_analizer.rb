module MonkeyLearnServices
  class SentimentAnalizer < ApplicationService
    URL = URI('https://api.monkeylearn.com/v3/classifiers/cl_pi3C7JiL/classify/')

    def initialize(comments)
      @comments = comments
    end

    def call
      initialize_request
      Net::HTTP.start(URL.host, URL.port, use_ssl: true) do |http|
        response = http.request(@req)
        response_data = JSON.parse(response.body)

        if response_data.is_a?(Hash) && response_data['status_code'] != 200
          raise NewslizerExceptions::SentimentAnalizerReturnedAnError
        end

        response_data
      end
    end

    private

    def initialize_request
      @req = Net::HTTP::Post.new(URL)
      @req['Authorization'] = "Token #{ENV['MONKEY_KEY']}"
      @req['Content-Type'] = 'application/json'
      @req.body = {
        data: @comments
      }.to_json
    end
  end
end
