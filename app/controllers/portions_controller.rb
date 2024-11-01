class PortionsController < ApplicationController
  before_action :set_portionable
  before_action :authorize_portions_access, only: [:edit, :update]

  def new
    @portion = @portionable.portions.new
  end

  def create
    @portion = @portionable.portions.new(portion_params)

    if @portion.save
      redirect_to @portionable, notice: 'Porção criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @portion = Portion.find(params[:id])
  end

  def update
    @portion = Portion.find(params[:id])

    if @portion.update(portion_params)
      redirect_to @portionable, notice: 'Porção atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_portionable
    @portionable = Dish.find(params[:dish_id]) if params[:dish_id]
    @portionable ||= Drink.find(params[:drink_id]) if params[:drink_id]
  end

  def portion_params
    params.require(:portion).permit(:description, :price)
  end

  def authorize_portions_access    
    unless current_user.restaurant == @portionable.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
