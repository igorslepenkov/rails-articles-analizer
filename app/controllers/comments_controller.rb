class CommentsController < ApplicationController
  def index
    @comments = Comment.where(article_id: comments_params)
  end

  private

  def comments_params
    params.require(:id)
  end
end
