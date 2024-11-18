class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_restaurant
  before_action :set_order, only: [:preparing, :ready, :cancel]

  def index
    if params[:status].present? && !Order.statuses.keys.include?(params[:status])
      render json: { error: "Status inválido" }, status: 400
    else
      orders = (
                params[:status].present? ?
                Order.where(status: params[:status], restaurant_id: @restaurant.id).order(created_at: :asc) :
                Order.where(restaurant_id: @restaurant.id).order(created_at: :asc)
               )
  
      render json: orders.as_json(except: [:updated_at]), status: 200
    end
  end

  def show
    order = Order.includes(order_items: [:dish, :drink, :portion]).find_by!(code: params[:code], restaurant_id: @restaurant.id)

    render json: order.as_json(
      except: [:updated_at, :customer_email, :customer_cpf, :restaurant_id],
      include: {
        order_items: {
          only: [:price, :note],
          include: {
            portion: { only: [:description] },
            drink: { only: [:name] },
            dish: { only: [:name] }
          }
        }
      }
    ), status: 200
  end

  def preparing
    if @order.awaiting_confirmation?
      @order.preparing!
      render json: { message: 'Status atualizado para "em preparação".' }, status: 200
    else
      render json: { error: "O pedido não está aguardando confirmação." }, status: 409
    end
  end

  def ready
    if @order.preparing?
      @order.ready!
      render json: { message: 'Status atualizado para "pronto".' }, status: 200
    else
      render json: { error: "O pedido não estava em preparação." }, status: 409
    end
  end

  def cancel
    reason = params[:reason]

    if reason.blank?
      return render json: { error: 'Motivo do cancelamento é obrigatório.' }, status: 400
    end

    if Order.statuses[@order.status] <= 1
      @order.status = "canceled"
      @order.cancellation_reason = reason
      @order.save!
      render json: { message: 'Status atualizado para "cancelado".' }, status: 200
    else
      render json: { error: "Somente pedidos aguardando confirmação ou em preparação podem ser cancelados." }, status: 409
    end
  end

  private

  def set_order
    @order = Order.find_by!(restaurant_id: @restaurant.id, code: params[:code])
  end

  def set_restaurant
    @restaurant = Restaurant.find_by!(code: params[:restaurant_code])
  end
end