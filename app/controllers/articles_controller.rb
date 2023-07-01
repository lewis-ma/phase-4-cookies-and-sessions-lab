class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1

    if session[:page_views] < 3
      # Render the JSON response with the article data
      article = Article.find(params[:id])
      render json: article
    else
      # Render the JSON response with the error message and status code 401
      render json: { error: "Unauthorized - Maximum page views reached" }, status: :unauthorized
    end
  end


end
