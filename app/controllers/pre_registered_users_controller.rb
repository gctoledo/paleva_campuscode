class PreRegisteredUsersController < ApplicationController
  def index
    @pre_registered_users = @restaurant.pre_registered_users
  end

  def new
    @pre_registered_user = PreRegisteredUser.new
  end

  def create
    @pre_registered_user = @restaurant.pre_registered_users.new(pre_registered_user_params)

    if @pre_registered_user.save
      redirect_to pre_registered_users_path, notice: "Usuário pré-cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def pre_registered_user_params
    params.require(:pre_registered_user).permit(:email, :cpf)
  end
end
