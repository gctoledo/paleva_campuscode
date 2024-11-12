class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_restaurant

  def index
    if params[:status].present? && !Order.statuses.keys.include?(params[:status])
      render json: { error: "Status inválido" }, status: 400
    else
      orders = (
                params[:status].present? ?
                Order.where(status: params[:status], restaurant_id: @restaurant.id).order(created_at: :desc) :
                Order.where(restaurant_id: @restaurant.id).order(created_at: :desc)
               )
  
      render json: orders.as_json(except: [:created_at, :updated_at]), status: 200
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
    order = Order.find_by!(restaurant_id: @restaurant.id, code: params[:code])

    if order.awaiting_confirmation?
      order.preparing!
      render json: { message: 'Status atualizado para "em preparação".' }, status: 200
    else
      render json: { error: "O pedido não está aguardando confirmação." }, status: 409
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by!(code: params[:restaurant_code])
  end
end