class DishesController < ApplicationController
  before_action :set_restaurant

  def index
    @dishes = @restaurant.dishes
  end

  def new
    @dish = @restaurant.dishes.new
  end

  def create
    @dish = @restaurant.dishes.new(dish_params)

    if @dish.save
      flash[:notice] = "Prato cadastrado com sucesso!"
      redirect_to dishes_path
    else
      flash.now[:alert] = "Erro ao cadastrar prato"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image)
  end
end