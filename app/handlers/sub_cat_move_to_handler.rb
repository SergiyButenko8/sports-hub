class SubCatMoveToHandler
  attr_reader :sub_category, :category_id

  def initialize(sub_category, params)
    @sub_category = sub_category
    @category_id = params[:move_to_cat_id]
  end

  def perform
    ActiveRecord::Base.transaction do
      if move_to_category.present? && sub_category.update(category: move_to_category)
        current_category.sub_categories.where("position > ?", sub_category.position).update_all("position = position-1")
        move_to_category.sub_categories.update_all("position = position+1")
        sub_category.update(position: 1)
      else
        false
      end
    end
  end

  private

  def move_to_category
    @move_to_category ||= Category.find_by(id: category_id)
  end

  def current_category
    @current_category ||= Category.find_by(id: sub_category.category_id)
  end
end
