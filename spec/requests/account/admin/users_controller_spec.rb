# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin users management', type: :request do
  let!(:current_admin) { create(:admin_user) }

  before do
    sign_in current_admin
  end

  describe '#index' do
    let!(:user) { create(:user) }
    let!(:blocked) { create(:blocked_user) }

    it 'returns http success' do
      get account_admin_users_path
      expect(response).to be_successful
    end

    it "assigns all users to @all_users" do
      get account_admin_users_path
      expect(assigns(:all_users)).to eq(User.all)
    end

    it "assigns all users match to query" do
      get account_admin_users_path, params: { q: { first_name_or_last_name_cont: 'Sergiy' } }
      expect(assigns(:all_users).size).to eq(3)
      expect(assigns(:all_users).first.first_name).to eq("Sergiy")
    end

    it "assigns only active users to @all_users" do
      get account_admin_users_path, params: { q: { status_eq: 0 } }
      expect(assigns(:all_users)).to eq(User.active)
    end

    it "assigns only blocked users to @all_users" do
      get account_admin_users_path, params: { q: { status_eq: 1 } }
      expect(assigns(:all_users)).to eq(User.blocked)
      expect(assigns(:all_users).first.id).to eq(blocked.id)
    end

    it "assigns online users only" do
      get account_admin_users_path, params: { q: { online: true } }
      expect(assigns(:all_users).size).to eq(User.online.size)
    end

    it "assigns offline users only" do
      get account_admin_users_path, params: { q: { offline: true } }
      expect(assigns(:all_users).size).to eq(User.offline.size)
    end

    it 'return to account user page if not admin' do
      sign_in user
      get account_admin_users_path
      expect(response).to have_http_status(:redirect)
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
        expect(response).to have_http_status(:redirect)
      end
    end

    context "when failed attempt" do
      before do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
      end

      it "return false when tries to delete" do
        expect do
          delete account_admin_user_path(user2)
        end.not_to change(User, :count)
      end
    end
  end
end
