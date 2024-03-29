class ArticlesController < ApplicationController
  def new
    @article = Article.new
  end

  def index
    if params[:query].present?
      sql_query = "title ILIKE :query OR note ILIKE :query"
      @articles = Article.where(sql_query, query: "%#{params[:query]}%")
    else
      @articles = Article.all
    end
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    @folder = Folder.find(params[:folder_id])
    if @article.save
      @connection = Connection.new(folder_id: @folder.id, article_id: @article.id)
      if @connection.save!
        redirect_to dashboard_path( anchor: "new_article-#{@article.id}")
      end
    else
      render :new
    end
  end

  def update #mark_as_done
    @article = Article.find(params[:id])
    @article.done!
    redirect_to dashboard_path
  end

  # def show
  #   article = Article.find(params[:id])
  # end

  private

  def article_params
    params.require(:article).permit(:title, :url, :note, :importance, :reminder)
  end
end
