# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authenticated user index page', type: :request do
  describe 'GET /account/users' do
    let(:user) { create(:user) }

    it 'returns http success' do
      sign_in user
      get account_users_path
      expect(response).to have_http_status(:success)
    end
  end
end
