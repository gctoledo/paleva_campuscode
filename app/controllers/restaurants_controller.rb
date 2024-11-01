class RestaurantsController < ApplicationController
  skip_before_action :check_restaurant, only: [:new, :create]
  skip_before_action :check_opentimes

  before_action :check_already_have_restaurant, only: [:new, :create]

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.build_restaurant(restaurant_params)

    if @restaurant.save
      flash[:notice] = "Restaurante cadastrado com sucesso!"
      redirect_to root_path
    else
      flash.now[:alert] = "Erro ao cadastrar restaurante"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:trade_name, :legal_name, :cnpj, :address, :phone, :email)
  end

  def check_already_have_restaurant
    if current_user.restaurant
      redirect_to root_path, alert: "Você já possui um restaurante cadastrado!"
    end
  end
end