# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:sub_category) }
  end
end
