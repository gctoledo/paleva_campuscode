class OpentimesController < ApplicationController
  skip_before_action :check_opentimes, only: [:index, :new, :create]
  before_action :set_restaurant

  def index
    @opentimes = @restaurant.opentimes
  end

  def new
    @opentimes = (0..6).map do |day|
      @restaurant.opentimes.find_or_initialize_by(week_day: day)
    end
  end

  def create
    ActiveRecord::Base.transaction do
      (0..6).each do |day|
        open_time = params[:open][day.to_s].presence
        close_time = params[:close][day.to_s].presence

        is_closed = open_time.nil? && close_time.nil?

        opentime = @restaurant.opentimes.new(
          week_day: day,
          open: open_time,
          close: close_time,
          closed: is_closed
        )

        unless opentime.save
          flash.now[:alert] = "Erro ao salvar horários de funcionamento para #{I18n.t('date.day_names')[day]}"
          render :new, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    end

    flash[:notice] = "Horários cadastrados com sucesso!"
    redirect_to root_path
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant  # Assumindo que o usuário só tem um restaurante
  end

  def opentime_params
    params.require(:opentime).permit(:open, :close)
  end
end