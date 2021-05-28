# frozen_string_literal: true

module Account
  # Common controller for authenticated users
  class AccountBaseController < ApplicationController
    before_action :authenticate_user!
    def index; end
  end
end
