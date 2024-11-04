class TagsController < ApplicationController
  before_action :authorize_tags_access, only: [:destroy]
  before_action :set_restaurant
  before_action :set_tag, only: [:destroy]

  def index
    @tags = @restaurant.tags
  end

  def new
    @tag = @restaurant.tags.new
  end

  def create
    @tag = @restaurant.tags.new(tag_params)

    if @tag.save
      redirect_to tags_path, notice: 'Marcador criado com sucesso.'
    else
      flash.now[:alert] = 'Erro ao criar marcador.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: 'Marcador excluído com sucesso.'
  end

  private

  def set_restaurant
    @restaurant = current_user.restaurant
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def authorize_tags_access
    tag = Tag.find(params[:id])

    unless tag.restaurant == current_user.restaurant
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end
end
