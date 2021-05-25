module Account
  class AccountBaseController < ApplicationController
    before_action :authenticate_user!
    def index

    end
  end
end
