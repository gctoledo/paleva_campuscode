class DrinksController < ApplicationController
  before_action :set_restaurant
  before_action :authorize_drinks_access, only: [:show, :edit, :update]

  def index
    @drinks = @restaurant.drinks
  end

  def show
    @drink = Drink.find(params[:id])
  end

  def new
    @drink = @restaurant.drinks.new
  end

  def create
    @drink = @restaurant.drinks.new(drink_params)

    if @drink.save
      flash[:notice] = "Bebida cadastrada com sucesso!"
      redirect_to drinks_path
    else
      flash.now[:alert] = "Erro ao cadastrar bebida"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @drink = Drink.find(params[:id])
  end

  def update
    @drink = Drink.find(params[:id])

    if @drink.update(drink_params)
      flash[:notice] = "Bebida atualizada com sucesso!"
      redirect_to drink_path(@drink.id)
    else
      flash.now[:alert] = "Erro ao atualizar bebida"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def drink_params
    params.require(:drink).permit(:name, :description, :alcoholic, :image)
  end

  def authorize_drinks_access
    drink = Drink.find(params[:id])
    unless drink.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end