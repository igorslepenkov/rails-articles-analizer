module RatingServices
  class ArticleRatingCalculator < ApplicationService
    NEUTRAL_RANGE = -20..20
    NEUTRAL_POINTS = NEUTRAL_RANGE.to_a.size
    NEGATIVE_SENTIMENT = 'Negative'
    POSITIVE_SENTIMENT = 'Positive'
    NEUTRAL_SENTIMENT = 'Neutral'

    def initialize(article)
      @article = article
    end

    def call
      filtered_comments = @article.comments.each_with_object({ positive: [], negative: [],
                                                               neutral: [] }) do |comment, acc|
        acc[:positive].push(comment) if comment.sentiment == POSITIVE_SENTIMENT
        acc[:negative].push(comment) if comment.sentiment == NEGATIVE_SENTIMENT
        acc[:neutral].push(comment) if comment.sentiment == NEUTRAL_SENTIMENT
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

      define_article_impact

      @article.save
    end

    private

    def define_article_impact
      case @article.rating
      when -20..20
        @article.impact = NEUTRAL_SENTIMENT
      when -100...-20
        @article.impact = NEGATIVE_SENTIMENT
      when 21..100
        @article.impact = POSITIVE_SENTIMENT
      end
    end
  end
end
