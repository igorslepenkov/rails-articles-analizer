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
      comments = response[:comments]
      if comments && !comments.empty?
        comments.each do |comment|
          comment_instance = Comment.create(text: comment, article_id: @article.id)
        end
      end

      redirect_to root_path
    else
      render 'new', status: :bad_request
    end
  end

  private

  def article_params
    params.require(:article).permit(:url)
  end
end
