module RatingServices
  class ArticleRatingCalculator < ApplicationService
    NEUTRAL_RANGE = -20..20
    NEUTRAL_POINTS = NEUTRAL_RANGE.to_a.size

    def initialize(article)
      @article = article
    end

    def call
      filtered_comments = @article.comments.reduce({positive: [], negative: [], neutral: []}) do |acc, comment|
        acc[:positive].push(comment) if comment.sentiment == 'Positive'
        acc[:negative].push(comment) if comment.sentiment == 'Negative'
        acc[:neutral].push(comment) if comment.sentiment == 'Neutral'
        acc
      end
      rating = 0
      if filtered_comments[:positive].empty? && filtered_comments[:negative].empty?
        confidence_arr = filtered_comments[:neutral].map { |comment| comment.confidence }
        avg_confidence = confidence_arr.sum(0.00) / 100 / confidence_arr.size
        rating = (avg_confidence * NEUTRAL_POINTS) - NEUTRAL_POINTS / 2
        @article.rating = rating
      else
        coef = (100 / (filtered_comments[:positive].size + filtered_comments[:negative].size)).round
        rating += filtered_comments[:positive].size * coef
        rating -= filtered_comments[:negative].size * coef
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
