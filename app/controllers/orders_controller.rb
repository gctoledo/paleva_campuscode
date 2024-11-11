class OrdersController < ApplicationController
  before_action :authorize_order_access, only: [:show]
  before_action :authorize_menu_access, only: [:new, :create]
  before_action :set_order, only: [:show]
  skip_before_action :authorize_employee_access

  def index
    @orders = @restaurant.orders.order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    load_menu_items
  end

  def create
    dishes = order_params[:order_items][:dishes]
    drinks = order_params[:order_items][:drinks]
  
    @order = @restaurant.orders.new(
      customer_cpf: order_params[:customer_cpf],
      customer_name: order_params[:customer_name],
      customer_email: order_params[:customer_email],
      customer_phone: order_params[:customer_phone],
    )
  
    if dishes.present?
      dishes.each do |dish_id, details|
        portion_id = details[:portion_id]
        note = details[:note]
        next if portion_id.blank?
  
        portion = Portion.find(portion_id)
        @order.add_order_item(portion: portion, dish: Dish.find(dish_id), note: note)
      end
    end
  
    if drinks.present?
      drinks.each do |drink_id, details|
        portion_id = details[:portion_id]
        note = details[:note]
        next if portion_id.blank?
  
        portion = Portion.find(portion_id)
        @order.add_order_item(portion: portion, drink: Drink.find(drink_id), note: note)
      end
    end
  
    if @order.save
      redirect_to @order, notice: 'Pedido criado com sucesso!'
    else
      flash.now[:alert] = 'Erro ao criar o pedido. Verifique os campos.'
      load_menu_items
      render :new, status: :unprocessable_entity
    end
  end  

  private

  def load_menu_items
    menu = params[:menu_id] ? @restaurant.menus.find(params[:menu_id]) : nil
  
    @dishes = menu&.dishes || @restaurant.dishes
    @drinks = menu&.drinks || @restaurant.drinks
  end  

  def order_params
    params.require(:order).permit(
      :customer_name, :customer_phone, :customer_email, :customer_cpf, order_items: { dishes: {}, drinks: {} })
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def authorize_order_access
    order = Order.find(params[:id])
    unless order.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def authorize_menu_access
    return unless params[:menu_id]

    menu = Menu.find(params[:menu_id])
    unless menu.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
