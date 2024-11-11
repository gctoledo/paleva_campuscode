class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :check_restaurant, unless: :devise_controller?
  before_action :check_opentimes, unless: :devise_controller?
  before_action :set_restaurant, unless: :devise_controller?
  before_action :authorize_employee_access, unless: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    flash[:alert] = "O item que você tentou acessar não existe."
    redirect_to root_path
  end

  def check_restaurant
    if !current_user.restaurant && current_user.owner?
      redirect_to new_restaurants_path, alert: "Você precisa cadastrar seu restaurante antes de continuar."
    end
  end

  def check_opentimes
    if current_user.restaurant && current_user.owner? && current_user.restaurant.opentimes.empty?
      redirect_to new_opentime_path, alert: "Você precisa cadastrar os horários de funcionamento do seu restaurante."
    end
  end

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def authorize_employee_access
    redirect_to root_path, alert: "Acesso não autorizado." unless current_user.owner?
  end
end
