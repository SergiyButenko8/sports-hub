# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin subcategories management', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:sub_category) { create(:sub_category, label: "new subcategory") }
  let!(:valid_params) { attributes_for :sub_category }
  let!(:invalid_params) { { label: '' } }
  let!(:category) { sub_category.category.id }

  before do
    sign_in admin
  end

  describe 'subcategories #index' do
    it 'returns http success' do
      get account_admin_category_sub_categories_path(category), xhr: true
      expect(response.content_type).to eq('text/javascript; charset=utf-8')
      expect(sub_category.category_id).to eq(category)
    end
  end

  describe '#new' do
    it 'returns success and assigns subcategory' do
      get new_account_admin_category_sub_category_path(category), xhr: true
      expect(response).to render_template('account/admin/sub_categories/new')
      expect(assigns(:sub_category)).to be_a_new(SubCategory)
    end
  end

  describe '#create' do
    context "with valid subcategory" do
      it "creates a new SubCategory" do
        expect do
          post account_admin_category_sub_categories_path(category),
               params: { sub_category: valid_params, format: :js }
        end.to change(SubCategory, :count).by(1)
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context "with too short subcategory" do
      it "return flash error" do
        expect do
          post account_admin_category_sub_categories_path(category),
               params: { sub_category: invalid_params, format: :js }
        end.not_to change(SubCategory, :count)
        expect(flash[:alert]).to match(/Label can't be blank */)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#edit' do
    it 'returns success and assigns subcategory' do
      get edit_account_admin_category_sub_category_path(category, sub_category), xhr: true
      expect(response).to render_template('account/admin/sub_categories/edit')
      expect(assigns(:sub_category)).to eq(sub_category)
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        put account_admin_category_sub_category_path(category, sub_category),
            params: { sub_category: valid_params.merge(label: "UpdatedSubCat"), format: :js }
      end

      it { expect(assigns(:sub_category)).to eq(sub_category) }

      it 'updates subcategory attributes' do
        expect(sub_category.reload.label).to eq("UpdatedSubCat")
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change subcategory" do
        expect do
          put account_admin_category_sub_category_path(category, sub_category), params: { sub_category: invalid_params }
        end.not_to change { sub_category.reload.label }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#move_position' do
    it 'updates subcategory position attribute' do
      expect do
        patch move_position_account_admin_category_sub_category_path(category, sub_category), params: { position: 299 }
      end.to change { sub_category.reload.position }.to(299)
    end
  end

  describe '#change_sub_cat_visibility' do
    context 'with valid params' do
      before do
        put change_sub_visibility_account_admin_category_sub_category_path(category, sub_category),
            params: { sub_category: valid_params.merge(hidden: true), format: :js }
      end

      it { expect(assigns(:sub_category)).to eq(sub_category) }

      it 'updates subcategory hidden attribute' do
        expect(sub_category.reload.hidden).to be_truthy
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change visibility" do
        expect do
          put change_sub_visibility_account_admin_category_sub_category_path(category, sub_category),
              params: { sub_category: valid_params.merge(hidden: false) }
        end.not_to change { sub_category.reload.hidden }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#move_to_category' do
    context "when valid params" do
      let!(:move_to_category) { create(:category, label: "new category") }

      it 'updates the inherit category and set notice flash' do
        expect do
          put move_to_category_account_admin_category_sub_category_path(category, sub_category),
              params: { move_to_cat_id: move_to_category.id, format: :js }
        end.to change { sub_category.reload.category_id }.to(move_to_category.id)
        expect(flash[:notice]).to be_present
      end
    end

    context "when failed attempt" do
      it 'does not update the inherit category and set alert flash' do
        expect do
          put move_to_category_account_admin_category_sub_category_path(category, sub_category),
              params: { move_to_cat_id: -222 }
        end.not_to change { sub_category.reload.category_id }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#destroy' do
    context "when valid params" do
      it 'destroys the subcategory and set flash' do
        expect do
          delete account_admin_category_sub_category_path(category, sub_category), params: { format: :js }
        end.to change(SubCategory, :count).by(-1)
        expect(flash[:notice]).to be_present
      end
    end

    context "when failed attempt" do
      before do
        allow_any_instance_of(SubCategory).to receive(:destroy).and_return(false)
      end

      it "return false when tries to delete" do
        expect do
          delete account_admin_category_sub_category_path(category, sub_category)
        end.not_to change(Category, :count)
      end
    end
  end
end
