class RestaurantsController < ApplicationController
  skip_before_action :check_restaurant, only: [:new, :create]
  skip_before_action :check_opentimes
  skip_before_action :set_restaurant

  before_action :check_already_have_restaurant, only: [:new, :create]

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
  
    if @restaurant.save
      current_user.update!(restaurant_id: @restaurant.id)
      
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