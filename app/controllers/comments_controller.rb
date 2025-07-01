# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_article
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_comment_owner, only: [:update, :destroy]

  # GET /articles/:article_id/comments
  def index
    render json: @article.comments
  end

  # POST /articles/:article_id/comments
  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/:article_id/comments/:id
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:article_id/comments/:id
  def destroy
    @comment.destroy
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_comment_owner
    unless @comment.user == current_user
      render json: { error: "Vous n'êtes pas autorisé." }, status: :forbidden
    end
  end
end