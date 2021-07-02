# frozen_string_literal: true

module Account::Admin
  class SubCategoriesController < AdminBaseController
    before_action :authorize_admin_user
    before_action :sub_categories, only: %i[index create update change_sub_visibility]

    def index; end

    def new
      @sub_category = category.sub_categories.new
    end

    def edit
      sub_category
    end

    def create
      @sub_category = category.sub_categories.build(sub_category_params)
      if @sub_category.save
        respond_to do |format|
          format.js { flash.now[:notice] = "Subcategory created successfully" }
        end
      else
        flash[:alert] = @sub_category.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def update
      if sub_category.update(sub_category_params)
        respond_to do |format|
          format.js { flash.now[:notice] = "Subcategory updated successfully" }
        end
      else
        flash[:alert] = sub_category.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def change_sub_visibility
      if sub_category.hidden?.to_s != sub_category_params[:hidden] && sub_category.update(sub_category_params)
        respond_to do |format|
          format.js do
            flash.now[:notice] =
              sub_category.hidden? ? "This subcategory is hidden now" : "This subcategory is visible now"
          end
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    def move_to_category
      handler = SubCatMoveToHandler.new(sub_category, params)
      if handler.perform
        respond_to do |format|
          format.js { flash.now[:notice] = "Subcategory successfully moved" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    def move_position
      sub_category.insert_at(params[:position].to_i)
      head :ok
    end

    def destroy
      if sub_category.destroy
        respond_to do |format|
          format.js { flash[:notice] = "Subcategory deleted successfully" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    private

    def sub_categories
      @sub_categories = category.sub_categories.order(position: :asc)
    end

    def sub_category_params
      params.require(:sub_category).permit(:label, :hidden)
    end

    def sub_category
      @sub_category ||= category.sub_categories.find(params[:id])
    end

    def category
      @category ||= Category.find(params[:category_id])
    end

    def authorize_admin_user
      authorize SubCategory
    end
  end
end
