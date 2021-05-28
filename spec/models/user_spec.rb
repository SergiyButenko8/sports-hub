# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#fullname' do
    let(:admin) { create(:admin_user) }
    let(:user) { create(:user, :empty_name) }

    it 'returns the full_name for a created user' do
      expect(admin.full_name).to eq 'Sergiy Butenko'
      expect(admin.role).to eq 'admin'
      expect(admin.status).to eq 'active'
    end

    it 'return --- if empty name' do
      expect(user.full_name).to eq '---'
    end
  end
end
