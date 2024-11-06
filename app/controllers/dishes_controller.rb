class DishesController < ApplicationController
  before_action :authorize_dishes_access, only: [:show, :edit, :update, :activate, :disable, :destroy]
  before_action :set_dish, only: [:show, :edit, :update, :activate, :disable, :destroy]

  def index
    @dishes = current_user.restaurant.dishes.includes(:tags)

    if params[:tag_names].present?
      @dishes = @dishes.joins(:tags).where(tags: { name: params[:tag_names] }).distinct
    end
  end

  def show; end

  def activate
    if @dish.active
      return redirect_to @dish, alert: 'Esse prato já está ativo.'
    end

    if @dish.update(active: true)
      redirect_to @dish, notice: 'Prato ativado com sucesso.'
    else
      redirect_to @dish, alert: 'Não foi possível ativar o prato. Tente novamente.'
    end
  end

  def disable
    if !@dish.active
      return redirect_to @dish, alert: 'Esse prato já está inativo.'
    end

    if @dish.update(active: false)
      redirect_to @dish, notice: 'Prato desativado com sucesso.'
    else
      redirect_to @dish, alert: 'Não foi possível desativar o prato. Tente novamente.'
    end
  end

  def new
    @dish = @restaurant.dishes.new
  end

  def create
    @dish = @restaurant.dishes.new(dish_params)
    
    if @dish.save
      add_tags if params[:new_tags].present?
      flash[:notice] = "Prato cadastrado com sucesso!"
      redirect_to dishes_path
    else
      flash.now[:alert] = "Erro ao cadastrar prato"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    params[:dish][:tag_ids] ||= []
    
    if @dish.update(dish_params)
      add_tags if params[:new_tags].present?
      flash[:notice] = "Prato atualizado com sucesso!"
      redirect_to dish_path(@dish.id)
    else
      flash.now[:alert] = "Erro ao atualizar prato"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dish.destroy!
    redirect_to dishes_path, notice: 'Prato excluído com sucesso.'
  end

  private

  def set_dish
    @dish = Dish.find(params[:id])
  end

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :image, tag_ids: [])
  end

  def authorize_dishes_access
    dish = Dish.find(params[:id])

    unless dish.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def add_tags
    tags = params[:new_tags].split(',').map(&:strip).reject(&:empty?)
  
    tags.each do |tag_name|
      tag = @dish.restaurant.tags.find_or_create_by(name: tag_name)
      
      @dish.tags << tag unless @dish.tags.include?(tag)
      @dish.save
    end
  end
end