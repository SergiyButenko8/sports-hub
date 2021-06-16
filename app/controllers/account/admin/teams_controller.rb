# frozen_string_literal: true

module Account::Admin
  class TeamsController < AdminBaseController
    before_action :categories, only: %i[index create update change_team_visibility]
    before_action :teams, only: %i[index create update change_team_visibility]
    before_action :authorize_admin_user

    def index
      @categories = Category.includes(:sub_categories).all
    end

    def new
      @team = sub_category.teams.new
    end

    def edit
      team
    end

    def create
      @team = sub_category.teams.build(team_params)
      if @team.save
        respond_to do |format|
          format.js { flash.now[:notice] = "Team created successfully" }
        end
      else
        flash[:alert] = @team.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def update
      if team.update(team_params)
        respond_to do |format|
          format.js { flash.now[:notice] = "Team updated successfully" }
        end
      else
        flash[:alert] = team.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def change_team_visibility
      if team.hidden?.to_s != team_params[:hidden] && team.update(team_params)
        respond_to do |format|
          format.js { flash.now[:notice] = team.hidden? ? "This team is hidden now" : "This team is visible now" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    def move_to_sub_category
      handler = TeamMoveToHandler.new(team, params)
      if handler.perform
        respond_to do |format|
          format.js { flash.now[:notice] = "Team successfully moved" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    def move_position
      team.insert_at(params[:position].to_i)
      head :ok
    end

    def destroy
      if team.destroy
        respond_to do |format|
          format.js { flash.now[:notice] = "Team deleted successfully" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    private

    def team_params
      params.require(:team).permit(:label, :hidden, :move_to_sub_cat_id)
    end

    def team
      @team ||= sub_category.teams.find(params[:id])
    end

    def teams
      @teams ||= sub_category.teams.order(position: :asc)
    end

    def category
      @category ||= Category.find(params[:category_id])
    end

    def sub_category
      @sub_category ||= category.sub_categories.find(params[:sub_category_id])
    end

    def categories
      @categories ||= Category.includes(:sub_categories).all
    end

    def authorize_admin_user
      authorize Team
    end
  end
end
