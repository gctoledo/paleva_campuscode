class OpentimesController < ApplicationController
  skip_before_action :check_opentimes, only: [:index, :new, :create]

  def index
    @opentimes = @restaurant.opentimes
  end

  def new
    @opentime = @restaurant.opentimes.new
  end

  def create
    @opentime = @restaurant.opentimes.new(opentime_params)

    if @opentime.save
      redirect_to opentimes_path, notice: 'Horário cadastrado com sucesso!'
    else
      flash.now[:alert] = 'Erro ao cadastrar o horário.'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def opentime_params
    params.require(:opentime).permit(:week_day, :open, :close, :closed).tap do |whitelisted|
      whitelisted[:closed] = whitelisted[:closed] == "1"
    end
  end
  
end