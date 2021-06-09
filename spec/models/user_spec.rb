# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#fullname' do
    let(:admin) { create(:admin_user) }

    it 'returns the full_name for a created user' do
      expect(admin.full_name).to eq 'Sergiy Butenko'
      expect(admin.role).to eq 'admin'
      expect(admin.status).to eq 'active'
    end
  end
end
