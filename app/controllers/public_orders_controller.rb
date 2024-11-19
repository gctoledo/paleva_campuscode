class PublicOrdersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_restaurant
  skip_before_action :check_opentimes
  skip_before_action :set_restaurant
  skip_before_action :authorize_employee_access
  layout "auth"

  def index; end

  def search
    @order = Order.includes(:restaurant).find_by!(code: params[:public_order_code])

    redirect_to track_order_path(@order.code)
  end

  def show
    @order = Order.includes(:restaurant).find_by!(code: params[:code])

    @history = {
      criado: @order.created_at,
      preparando: @order.preparing_at,
      pronto: @order.ready_at,
      entregue: @order.delivered_at
    }.compact
  end

  private

  def not_found
    flash[:alert] = "Pedido não encontrado"
    redirect_to track_orders_path
  end
end