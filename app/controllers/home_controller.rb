class HomeController < ApplicationController
  skip_before_action :check_opentimes, only: [:index]

  def index; end
end