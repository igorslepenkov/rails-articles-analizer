class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(url: article_params[:url])

    response = CapybaraServices::Parser.parse_digital_ocean_article(@article.url)

    @article[:title] = response[:title]

    if @article.save
      comments = response[:comments].first(50)
      if comments && !comments.empty?
        analized_comments = MonkeyLearnServices::SemanticAnalizer.analize_comments(comments)
        analized_comments.each do |analyzed_comment|
          Comment.create(text: analyzed_comment['text'], 
                          article_id: @article.id, 
                          sentiment: analyzed_comment['classifications'][0]['tag_name'],
                          confidence: analyzed_comment['classifications'][0]['confidence'] * 100)
        end
        calculate_article_rating(@article)
      end
      
      redirect_to articles_path
    else
      render 'new', status: :bad_request
    end
  end

  private

  def article_params
    params.require(:article).permit(:url)
  end

  def calculate_article_rating(article)
    article_comments = article.comments
    positive = article.comments.filter { |comment| comment.sentiment == 'Positive' }
    negative = article.comments.filter { |comment| comment.sentiment == 'Negative' }
    rating = 0
    if positive.empty? && negative.empty?
      neutral = article.comments.filter { |comment| comment.sentiment == 'Neutral' }
      confidence_arr = neutral.map { |comment| comment.confidence }
      avg_confidence = confidence_arr.sum(0.00) / confidence_arr.size
      rating = (avg_confidence * 40) - 20
      article.rating = rating
    else
      coef = (100 / (positive.size + negative.size)).round
      positive.each { rating += coef }
      negative.each { rating -= coef }
      article.rating = rating
    end

    case article.rating
    when -20..20
      article.impact = 'Neutral'
    when -100...-20
      article.impact = 'Negative'
    when 21..100
      article.impact = 'Positive'
    end

    article.save
  end
end
