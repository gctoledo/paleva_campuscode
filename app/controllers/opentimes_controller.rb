class OpentimesController < ApplicationController
  skip_before_action :check_opentimes, only: [:new, :create]

  def new
  end

  def create
  end
end