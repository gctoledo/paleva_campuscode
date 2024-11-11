class DrinksController < ApplicationController
  before_action :authorize_drinks_access, only: [:show, :edit, :update, :activate, :disable, :destroy]
  before_action :set_drink, only: [:show, :edit, :update, :activate, :disable, :destroy]
  skip_before_action :authorize_employee_access, only: [:index, :show]

  def index
    @drinks = @restaurant.drinks
  end

  def activate
    if @drink.active
      return redirect_to @drink, alert: 'Essa bebida já está ativa.'
    end

    if @drink.update(active: true)
      redirect_to @drink, notice: 'Bebida ativada com sucesso.'
    else
      redirect_to @drink, alert: 'Não foi possível ativar a bebida. Tente novamente.'
    end
  end

  def disable
    if !@drink.active
      return redirect_to @drink, alert: 'Essa bebida já está inativa.'
    end

    if @drink.update(active: false)
      redirect_to @drink, notice: 'Bebida desativada com sucesso.'
    else
      redirect_to @drink, alert: 'Não foi possível desativar a bebida. Tente novamente.'
    end
  end

  def show;  end

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

  def edit;  end

  def update
    if @drink.update(drink_params)
      flash[:notice] = "Bebida atualizada com sucesso!"
      redirect_to drink_path(@drink.id)
    else
      flash.now[:alert] = "Erro ao atualizar bebida"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @drink.soft_delete
      flash[:notice] = "Bebida excluída com sucesso."
    else
      flash[:alert] = "Erro ao excluir bebida."
    end
    redirect_to drinks_path
  end

  private

  def set_drink
    @drink = Drink.unscoped.find(params[:id])
  end

  def drink_params
    params.require(:drink).permit(:name, :description, :alcoholic, :image)
  end

  def authorize_drinks_access
    drink = Drink.unscoped.find(params[:id])
    unless drink.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end