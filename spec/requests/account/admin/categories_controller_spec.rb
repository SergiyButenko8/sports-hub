# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin categories management', type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:category) { create(:category, label: "new cat") }
  let!(:category_params) { attributes_for :category }
  let!(:invalid_cat_params) { { label: '' } }

  before do
    sign_in admin
  end

  describe 'categories #index' do
    it 'returns http success' do
      get account_admin_categories_path
      expect(response).to be_successful
    end
  end

  describe '#new' do
    it 'returns success and assigns category' do
      get new_account_admin_category_path, xhr: true
      expect(response).to render_template('account/admin/categories/new')
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe '#edit' do
    it 'returns success and assigns category' do
      get edit_account_admin_category_path(category), xhr: true
      expect(response).to render_template('account/admin/categories/edit')
      expect(assigns(:category)).to eq(category)
    end
  end

  describe '#create' do
    context "with valid category" do
      it "creates a new Category" do
        expect do
          post account_admin_categories_path, params: { category: category_params, format: :js }
        end.to change(Category, :count).by(1)
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context "with too short category" do
      it "return flash error" do
        expect do
          post account_admin_categories_path, params: { category: { label: "tc" } }
        end.not_to change(Category, :count)
        expect(flash[:alert]).to match(/Label is too short .*/)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        put account_admin_category_path(category),
            params: { category: category_params.merge(label: "Updated"), format: :js }
      end

      it { expect(assigns(:category)).to eq(category) }

      it 'updates category attributes' do
        expect(category.reload.label).to eq("Updated")
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change category" do
        expect do
          put account_admin_category_path(category), params: { category: invalid_cat_params }
        end.not_to change { category.reload.label }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#move_position' do
    it 'updates category position attribute' do
      expect do
        patch move_position_account_admin_category_path(category), params: { position: 299, format: :js }
      end.to change { category.reload.position }.to(299)
    end
  end

  describe '#change_cat_visibility' do
    context 'with valid params' do
      before do
        put change_cat_visibility_account_admin_category_path(category),
            params: { category: category_params.merge(hidden: true), format: :js }
      end

      it { expect(assigns(:category)).to eq(category) }

      it 'updates category hidden attribute' do
        expect(category.reload.hidden).to be_truthy
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change visibility" do
        expect do
          put change_cat_visibility_account_admin_category_path(category),
              params: { category: category_params.merge(hidden: false) }
        end.not_to change { category.reload.hidden }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#destroy' do
    context "when valid params" do
      it 'destroys the category and set flash' do
        expect do
          delete account_admin_category_path(category), params: { format: :js }
        end.to change(Category, :count).by(-1)
        expect(flash[:notice]).to be_present
        # expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context "when failed attempt" do
      before do
        allow_any_instance_of(Category).to receive(:destroy).and_return(false)
      end

      it "return false when tries to delete" do
        expect do
          delete account_admin_category_path(category)
        end.not_to change(Category, :count)
      end
    end
  end
end
