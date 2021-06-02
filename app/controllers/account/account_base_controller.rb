# frozen_string_literal: true

module Account
  # Common controller for authenticated users
  class AccountBaseController < ApplicationController
    layout "user_layout"
    before_action :authenticate_user!

    def index; end
  end
end
