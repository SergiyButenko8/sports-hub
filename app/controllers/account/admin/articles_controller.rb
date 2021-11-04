# frozen_string_literal: true

module Account::Admin
  class ArticlesController < AdminBaseController
    before_action :set_page_title
    before_action :article, :sub_categories, :teams, only: %i[edit]

    def index
      @articles = category.articles.order(created_at: :desc)
    end

    def new
      sub_categories
      teams
      @article = Article.new
    end

    def show
      article
    end

    def edit; end

    def update
      if article.update(article_params)
        flash[:notice] = "Article updated"
        redirect_to account_admin_category_articles_path
      else
        flash[:alert] = "Something went wrong"
        render "account/admin/articles/edit"
      end
    end

    def create
      sub_categories
      teams
      @article = category.articles.build(article_params)
      if @article.save
        flash[:notice] = "Article created successfully"
        redirect_to account_admin_category_articles_path
      else
        flash[:alert] = @article.errors.full_messages.to_sentence
        render 'account/admin/articles/new'
      end
    end

    def populate_team_list
      category
      sub_categories
      sub_category = SubCategory.find_by(id: params[:id])
      @teams = sub_category.teams
      respond_to do |format|
        format.js
      end
    end

    def destroy
      if article.destroy
        flash[:notice] = "Article was deleted successfully"
      else
        flash[:alert] = "Something went wrong"
      end
      redirect_to account_admin_category_articles_path
    end

    def change_publish_status
      article
      if article.published != article_params[:published] && article.update(article_params)
        flash[:notice] = article.published? ? "Article is published now" : "Article is unpublished now"
      else
        flash[:alert] = "Something went wrong"
      end
      redirect_to account_admin_category_articles_path
    end

    def move_article_to_category
      handler = ArticleMoveToHandler.new(article, params)
      if handler.perform
        flash[:notice] = "Article successfully moved"
      else
        flash[:alert] = "Something went wrong"
      end
      redirect_to account_admin_category_articles_path
    end

    private

    def category
      @category ||= Category.find(params[:category_id])
    end

    def sub_categories
      @sub_categories ||= category.sub_categories.order(position: :asc).includes(:teams)
    end

    def teams
      @teams ||= Team.all.order(position: :asc)
    end

    def set_page_title
      @page_title = category.label.upcase
    end

    def article
      @article ||= Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:alt, :headline, :caption, :content, :image, :commented, :published,
                                      :sub_category_id, :team_id, :image)
    end
  end
end
