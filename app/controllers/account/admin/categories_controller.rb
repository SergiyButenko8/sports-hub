# frozen_string_literal: true

module Account::Admin
  class CategoriesController < AdminBaseController
    before_action :set_page_title
    before_action :authorize_admin_user

    def index; end

    def new
      @category = Category.new
    end

    def edit
      category
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        respond_to do |format|
          format.js { flash.now[:notice] = "Category created successfully" }
        end
      else
        flash[:alert] = @category.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def update
      if category.update(category_params)
        respond_to do |format|
          format.js { flash.now[:notice] = "Category updated successfully" }
        end
      else
        flash[:alert] = category.errors.full_messages.to_sentence
        redirect_to account_admin_categories_path
      end
    end

    def change_cat_visibility
      if category.hidden?.to_s != (category_params[:hidden]) && category.update(category_params)
        respond_to do |format|
          format.js do
            flash.now[:notice] = category.hidden? ? "This category is hidden now" : "This category is visible now"
          end
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    def move_position
      category.insert_at(params[:position].to_i)
      respond_to do |format|
        format.js
      end
    end

    def destroy
      if category.destroy
        respond_to do |format|
          format.js { flash.now[:notice] = "Category deleted successfully" }
        end
      else
        flash[:alert] = "Something went wrong"
        redirect_to account_admin_categories_path
      end
    end

    private

    def category_params
      params.require(:category).permit(:label, :hidden)
    end

    def category
      @category ||= Category.find(params[:id])
    end

    def authorize_admin_user
      authorize Category
    end

    def set_page_title
      @page_title = "Information Architecture"
    end
  end
end
