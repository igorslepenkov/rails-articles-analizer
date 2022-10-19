module RatingServices
  class ArticleRatingCalculator < ApplicationService
    def initialize(article)
      @article = article
    end

    def call
      article_comments = @article.comments
      positive = @article.comments.filter { |comment| comment.sentiment == 'Positive' }
      negative = @article.comments.filter { |comment| comment.sentiment == 'Negative' }
      rating = 0
      if positive.empty? && negative.empty?
        neutral = @article.comments.filter { |comment| comment.sentiment == 'Neutral' }
        confidence_arr = neutral.map { |comment| comment.confidence }
        avg_confidence = confidence_arr.sum(0.00) / 100 / confidence_arr.size
        rating = (avg_confidence * 40) - 20
        @article.rating = rating
      else
        coef = (100 / (positive.size + negative.size)).round
        positive.each { rating += coef }
        negative.each { rating -= coef }
        @article.rating = rating
      end
  
      case @article.rating
      when -20..20
        @article.impact = 'Neutral'
      when -100...-20
        @article.impact = 'Negative'
      when 21..100
        @article.impact = 'Positive'
      end
  
      @article.save
    end
  end
end

