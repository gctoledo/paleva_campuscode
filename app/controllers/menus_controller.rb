class MenusController < ApplicationController
  before_action :authorize_menu_access, only: [:show, :edit, :update, :destroy]
  before_action :set_menu, only: [:show, :edit, :update, :destroy]
  skip_before_action :check_opentimes, only: [:index]

  def index
    @menus = @restaurant.menus
  end

  def show
    @active_dishes = @menu.dishes.where(active: true)
    @active_drinks = @menu.drinks.where(active: true)
  end

  def new
    @menu = @restaurant.menus.new
  end

  def create
    @menu = @restaurant.menus.new(menu_params)

    if @menu.save
      redirect_to menus_path, notice: 'Cardápio criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @menu.update(menu_params)
      redirect_to @menu, notice: 'Cardápio atualizado com sucesso'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu.destroy
    redirect_to menus_path, notice: 'Cardápio excluído com sucesso.'
  end

  private

  def menu_params
    params.require(:menu).permit(:name, dish_ids: [], drink_ids: [])
  end

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def authorize_menu_access
    menu = Menu.find(params[:id])
    unless menu.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end