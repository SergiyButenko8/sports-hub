class TeamMoveToHandler
  attr_reader :team, :sub_category_id

  def initialize(team, params)
    @team = team
    @sub_category_id = params[:move_to_sub_cat_id]
  end

  def perform
    if move_to_sub_category.present? && team.update(sub_category: move_to_sub_category)
      current_sub_category.teams.where("position > ?", team.position).update_all("position = position-1")
      move_to_sub_category.teams.update_all("position = position+1")
      team.update(position: 1)
    else
      false
    end
  end

  private

  def move_to_sub_category
    @move_to_sub_category ||= SubCategory.find_by(id: sub_category_id)
  end

  def current_sub_category
    @current_sub_category ||= SubCategory.find_by(id: team.sub_category_id)
  end
end
