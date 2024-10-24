class OpentimesController < ApplicationController
  skip_before_action :check_opentimes, only: [:index, :new, :create]

  before_action :set_restaurant

  def index
    @opentimes = @restaurant.opentimes
  end

  def new
    @opentime = @restaurant.opentimes.new
  end

  def create
    @opentime = @restaurant.opentimes.new(opentime_params)

    if Opentime.exists?(restaurant_id: @restaurant.id, week_day: opentime_params[:week_day])
      flash.now[:alert] = 'Você já cadastratou esse dia.'
      render :new, status: :unprocessable_entity
      return
    end

    if @opentime.save
      redirect_to opentimes_path, notice: 'Horário cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Erro ao cadastrar o horário. Verifique os campos.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def opentime_params
    params.require(:opentime).permit(:week_day, :open, :close, :closed).tap do |whitelisted|
      whitelisted[:closed] = whitelisted[:closed] == "1"
    end
  end
  
end