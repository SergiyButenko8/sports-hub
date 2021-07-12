# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Account::Admin::TeamsController, type: :request do
  let!(:admin) { create(:admin_user) }
  let!(:team) { create(:team, label: "new team.") }
  let!(:valid_params) { attributes_for :team }
  let!(:invalid_params) { { label: '' } }
  let!(:sub_category) { team.sub_category }
  let!(:category) { sub_category.category }

  before do
    sign_in admin
  end

  describe 'subcategories #index' do
    it 'returns http success' do
      get account_admin_category_sub_category_teams_path(category, sub_category), xhr: true
      expect(response.content_type).to eq('text/javascript; charset=utf-8')
      expect(response).to render_template('account/admin/teams/index')
    end
  end

  describe '#new' do
    it 'returns success and assigns team' do
      get new_account_admin_category_sub_category_team_path(category, sub_category), xhr: true
      expect(response).to render_template('account/admin/teams/new')
      expect(assigns(:team)).to be_a_new(Team)
    end
  end

  describe '#create' do
    context "with valid team" do
      it "creates a new team" do
        expect do
          post account_admin_category_sub_category_teams_path(category, sub_category),
               params: { team: valid_params, format: :js }
        end.to change(Team, :count).by(1)
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context "with empty team" do
      it "return flash error" do
        expect do
          post account_admin_category_sub_category_teams_path(category, sub_category),
               params: { team: invalid_params, format: :js }
        end.not_to change(Team, :count)
        expect(flash[:alert]).to match(/Label can't be blank */)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#edit' do
    it 'returns success and assigns team' do
      get edit_account_admin_category_sub_category_team_path(category, sub_category, team), xhr: true
      expect(response).to render_template('account/admin/teams/edit')
      expect(assigns(:team)).to eq(team)
    end
  end

  describe '#update' do
    context 'with valid params' do
      before do
        put account_admin_category_sub_category_team_path(category, sub_category, team),
            params: { team: valid_params.merge(label: "UpdatedTeam"), format: :js }
      end

      it { expect(assigns(:team)).to eq(team) }

      it 'updates team attributes' do
        expect(team.reload.label).to eq("UpdatedTeam")
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change subcategory" do
        expect do
          put account_admin_category_sub_category_team_path(category, sub_category, team),
              params: { team: invalid_params }
        end.not_to change { team.reload.label }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#move_position' do
    it 'updates team position attribute' do
      expect do
        patch move_position_account_admin_category_sub_category_team_path(category, sub_category, team),
              params: { position: 299 }
      end.to change { team.reload.position }.to(299)
    end
  end

  describe '#change_team_visibility' do
    context 'with valid params' do
      before do
        put change_team_visibility_account_admin_category_sub_category_team_path(category, sub_category, team),
            params: { team: valid_params.merge(hidden: true), format: :js }
      end

      it { expect(assigns(:team)).to eq(team) }

      it 'updates team hidden attribute' do
        expect(team.reload.hidden).to be_truthy
        expect(flash[:notice]).to be_present
        expect(response.content_type).to eq('text/javascript; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it "does not change visibility" do
        expect do
          put change_team_visibility_account_admin_category_sub_category_team_path(category, sub_category, team),
              params: { team: valid_params.merge(hidden: false) }
        end.not_to change { team.reload.hidden }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#move_to_category' do
    context "when valid params" do
      let(:move_to_sub_category) { create(:sub_category, label: "new susgdfbcategory") }

      it 'updates the inherit category and set notice flash' do
        expect do
          put move_to_sub_category_account_admin_category_sub_category_team_path(category, sub_category, team),
              params: { move_to_sub_cat_id: move_to_sub_category.id, format: :js }
        end.to change { team.reload.sub_category_id }.to(move_to_sub_category.id)
        expect(flash[:notice]).to be_present
      end
    end

    context "when failed attempt" do
      it 'does not update the inherit category and set alert flash' do
        expect do
          put move_to_sub_category_account_admin_category_sub_category_team_path(category, sub_category, team),
              params: { move_to_sub_cat_id: -222 }
        end.not_to change { team.reload.sub_category_id }
        expect(flash[:alert]).to be_present
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(account_admin_categories_path)
      end
    end
  end

  describe '#destroy' do
    context "when valid params" do
      it 'destroys the team and set flash' do
        expect do
          delete account_admin_category_sub_category_team_path(category, sub_category, team), params: { format: :js }
        end.to change(Team, :count).by(-1)
        expect(flash[:notice]).to be_present
      end
    end

    context "when failed attempt" do
      before do
        allow_any_instance_of(Team).to receive(:destroy).and_return(false)
      end

      it "return false when tries to delete" do
        expect do
          delete account_admin_category_sub_category_team_path(category, sub_category, team)
        end.not_to change(Team, :count)
      end
    end
  end
end
