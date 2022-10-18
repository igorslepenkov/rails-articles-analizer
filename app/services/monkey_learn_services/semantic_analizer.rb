module MonkeyLearnServices
  module SemanticAnalizer
    URL = URI('https://api.monkeylearn.com/v3/classifiers/cl_pi3C7JiL/classify/')

    @req = Net::HTTP::Post.new(URL)
    @req['Authorization'] = "Token #{ENV['MONKEY_KEY']}"
    @req['Content-Type'] = 'application/json'

    def self.analize_comments(comments)
      @req.body = {
        data: comments
      }.to_json
      Net::HTTP.start(URL.host, URL.port, use_ssl: true) do |http|
        JSON.parse(http.request(@req).body)
      end
    end
  end
end
