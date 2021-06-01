# frozen_string_literal: true

module Account
  class UsersController < AccountBaseController
    def index
      render 'account/index'
    end
  end
end
