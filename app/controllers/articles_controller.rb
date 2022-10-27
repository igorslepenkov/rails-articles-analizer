class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(url: article_params[:url])

    response = get_parser_response(@article.url)

    @article[:title] = response[:title]

    if @article.save
      comments = response[:comments].first(50)
      if comments && !comments.empty?
        analized_comments = MonkeyLearnServices::SentimentAnalizer.call(comments)
        analized_comments.each do |analyzed_comment|
          Comment.create(text: analyzed_comment['text'],
                         article_id: @article.id,
                         sentiment: analyzed_comment['classifications'][0]['tag_name'],
                         confidence: analyzed_comment['classifications'][0]['confidence'] * 100)
        end
        RatingServices::ArticleRatingCalculator.call(@article)
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

  def get_parser_response(url)
    host = URI(url).host
    case host
    when 'dev.to'
      CapybaraServices::DevToParser.call(url)
    when 'www.digitalocean.com'
      CapybaraServices::DigitalOceanParser.call(url)
    else
      raise NewslizerExceptions::DomainNotSupported.new
    end
  end
end
