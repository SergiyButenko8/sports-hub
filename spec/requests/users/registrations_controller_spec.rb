# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do
  let!(:valid_user) { FactoryBot.build(:user).attributes.merge({ password: '12345678' }) }
  let!(:invalid_user) { FactoryBot.build(:user).attributes.merge({ password: '12345' }) }

  describe '#create' do
    context "with valid user" do
      it "creates a new User" do
        expect do
          post user_registration_path, params: { user: valid_user }
        end.to change(User, :count).by(1)
      end
    end

    context "with invalid user" do
      it "does not create new user" do
        expect do
          post user_registration_path, params: { user: invalid_user }
        end.not_to change(User, :count)
      end
    end
  end
end
