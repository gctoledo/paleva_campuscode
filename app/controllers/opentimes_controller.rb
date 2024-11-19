class OpentimesController < ApplicationController
  before_action :authorize_opentime_access, only: [:edit, :update]
  skip_before_action :check_opentimes, only: [:index, :new, :create]
  before_action :set_opentime, only: [:edit, :update]

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

  def edit; end

  def update
    if @opentime.update(opentime_params)
      redirect_to opentimes_path, notice: 'Horário atualizado com sucesso'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def opentime_params
    params.require(:opentime).permit(:week_day, :open, :close, :closed).tap do |whitelisted|
      whitelisted[:closed] = whitelisted[:closed] == "1"
    end
  end

  def authorize_opentime_access
    opentime = Opentime.find(params[:id])
    unless opentime.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
  
  def set_opentime
    @opentime = Opentime.find(params[:id])
  end
end