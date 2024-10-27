class DishesController < ApplicationController
  before_action :set_restaurant
  before_action :authorize_dishes_access, only: [:show]

  def index
    @dishes = @restaurant.dishes
  end

  def show
    @dish = Dish.find(params[:id])
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

  def authorize_dishes_access
    dish = Dish.find(params[:id])
    unless dish.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end