class CommentsController < ApplicationController
  def index
    @article = Article.find(comments_params)
    @comments = Comment.where(article_id: @article.id)
  end

  private

  def comments_params
    params.require(:article_id)
  end
end
