# frozen_string_literal: true

# Default pages controller
class PagesController < ApplicationController
  def home
    render 'pages/home'
  end
end
