class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_restaurant, unless: :devise_controller?

  private

  def check_restaurant
    if current_user && !current_user.restaurant
      redirect_to new_restaurant_path, alert: "Você precisa cadastrar seu restaurante antes de continuar."
    end
  end
end
