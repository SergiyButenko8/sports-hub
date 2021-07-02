# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:sub_categories) }
  end
end
