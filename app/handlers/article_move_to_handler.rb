class ArticleMoveToHandler
  attr_reader :article, :category_id

  def initialize(article, params)
    @article = article
    @category_id = params[:dest_category_id]
  end

  def perform
    new_category.present? && article.update(category: new_category, sub_category_id: nil, team_id: nil)
  end

  private

  def new_category
    @new_category ||= Category.find_by(id: category_id)
  end
end
