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
  
      render json: orders.as_json(except: [:created_at, :updated_at]), status: :ok
    end
  end
  

  private

  def set_restaurant
    @restaurant = Restaurant.find_by!(code: params[:restaurant_code])
  end
end