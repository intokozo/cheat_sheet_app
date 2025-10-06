class ArticlesController < ApplicationController
  before_action :set_section, except: [ :index ]
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  def index
    @articles = Article.includes(:section).all
  end

  def show
  end

  def new
    @article = @section.articles.new
  end

  def create
    @article = @section.articles.new(article_params)
    if @article.save
      redirect_to section_article_path(@section, @article), notice: "Статья создана"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to section_article_path(@section, @article), notice: "Статья обновлена"
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to section_path(@section), notice: "Статья удалена"
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
