# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  # On exige un utilisateur authentifié, sauf pour voir la liste des articles et un article spécifique.
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authorize_owner, only: [:update, :destroy]

  # GET /articles
  def index
    @articles = Article.all
    render json: @articles
  end

  # GET /articles/1
  def show
    # On vérifie si l'article est privé ET si l'utilisateur n'est pas le propriétaire
    if @article.private? && @article.user != current_user
      render json: { error: "Cet article est privé." }, status: :forbidden
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    # On crée un nouvel article en l'associant directement à l'utilisateur connecté
    @article = current_user.articles.build(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private
    # Utilise des callbacks pour partager la configuration ou les contraintes communes entre les actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Seuls les paramètres de la "liste blanche" sont autorisés.
    def article_params
      params.require(:article).permit(:title, :content, :private)
    end

    # Vérifie si l'utilisateur connecté est bien le propriétaire de l'article
    def authorize_owner
      unless @article.user == current_user
        render json: { error: "Vous n'êtes pas autorisé à effectuer cette action." }, status: :forbidden
      end
    end
end