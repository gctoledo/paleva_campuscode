class RestaurantsController < ApplicationController
  skip_before_action :check_restaurant, only: [:new, :create]

  def new; end

  def create; end
end