class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_restaurant, unless: :devise_controller?
  before_action :check_opentimes, unless: :devise_controller?

  private

  def check_restaurant
    if !current_user.restaurant
      redirect_to new_restaurants_path, alert: "Você precisa cadastrar seu restaurante antes de continuar."
    end
  end

  def check_opentimes
    if current_user.restaurant && current_user.restaurant.opentimes.empty?
      redirect_to new_opentime_path, alert: "Você precisa cadastrar os horários de funcionamento do seu restaurante."
    end
  end
end
