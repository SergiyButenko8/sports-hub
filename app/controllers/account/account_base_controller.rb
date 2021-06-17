# frozen_string_literal: true

module Account
  # Common controller for authenticated users
  class AccountBaseController < ApplicationController
    before_action :authenticate_user!, :user_activity

    def user_activity
      current_user.update_column(:last_seen, Time.current)
    end
  end
end
