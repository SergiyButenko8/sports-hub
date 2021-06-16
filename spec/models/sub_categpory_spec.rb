# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:teams) }
  end
end
