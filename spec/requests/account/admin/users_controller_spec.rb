# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin users management', type: :request do
  let!(:current_admin) { create(:admin_user) }

  before do
    sign_in current_admin
  end

  describe '#index' do
    let(:user) { create(:user) }

    it 'returns http success' do
      get account_admin_users_path
      expect(response).to be_successful
    end

    it 'return to account user page if not admin' do
      sign_in user
      get account_admin_users_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe '#update' do
    context "when user params are valid" do
      it "updates" do
        current_first_name = current_admin.first_name
        expect do
          put account_admin_user_path(current_admin), params: { user: { first_name: "John" } }
        end.to change { current_admin.reload.first_name }.from(current_first_name).to("John")
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when user params are invalid" do
      it "not updates" do
        expect do
          put account_admin_user_path(current_admin), params: { user: { email: "" } }
        end.not_to change { current_admin.reload.first_name }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe '#change_admin_permission' do
    context "with active status" do
      let!(:admin) { create(:admin_user) }

      it "remove admin permission" do
        expect do
          put change_admin_permission_account_admin_user_path(admin), params: { user: { role: "user" } }
        end.to change { admin.reload.role }.from("admin").to("user")
        expect(response).to have_http_status(:redirect)
      end

      it "not allow to remove admin permission for own account" do
        expect do
          put change_admin_permission_account_admin_user_path(current_admin), params: { user: { role: "user" } }
        end.not_to change { current_admin.reload.role }
        expect(response).to have_http_status(:redirect)
      end

      it "not allow setting wrong parameter" do
        expect do
          put change_admin_permission_account_admin_user_path(admin), params: { user: { role: "user1" } }
        end.to raise_error(ArgumentError)
      end

      it "not allow change role to current" do
        expect do
          put change_admin_permission_account_admin_user_path(admin), params: { user: { role: "admin" } }
        end.not_to change { admin.reload.role }
        expect(response).to have_http_status(:redirect)
      end
    end

    context "with blocked status" do
      let(:blocked_user) { create(:blocked_user) }

      it "not allow to change user role" do
        expect do
          put change_admin_permission_account_admin_user_path(blocked_user), params: { user: { role: "admin" } }
        end.not_to change { blocked_user.reload.role }
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe '#change_user_status' do
    let(:user) { create(:user) }

    context "when user params are valid" do
      it "successful status update" do
        expect do
          put change_user_status_account_admin_user_path(user), params: { user: { status: "blocked" } }
        end.to change { user.reload.status }.from("active").to("blocked")
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when user params are invalid" do
      it "successful status update" do
        expect do
          put change_user_status_account_admin_user_path(user), params: { user: { status: "unblocked" } }
        end.to raise_error(ArgumentError)
      end

      it "not allow change status to current" do
        expect do
          put change_user_status_account_admin_user_path(user), params: { user: { status: "active" } }
        end.not_to change { user.reload.status }
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe '#destroy' do
    let!(:user2) { create(:admin_user) }

    context "when user params are valid" do
      it "deletes an admin by id" do
        expect do
          delete account_admin_user_path(user2)
        end.to change(User, :count).by(-1)
      end

      it "is not able to delete themself" do
        expect do
          delete account_admin_user_path(current_admin)
        end.not_to change(User, :count)
      end
    end
  end
end
