# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "auth"
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def create
    pre_registration = PreRegisteredUser.find_by(email: sign_up_params[:email]) || PreRegisteredUser.find_by(cpf: sign_up_params[:cpf])
  
    if pre_registration
      if pre_registration.email == sign_up_params[:email] && pre_registration.cpf == sign_up_params[:cpf]
        self.resource = User.new(sign_up_params)
        resource.restaurant_id = pre_registration.restaurant_id
        resource.role = 1
  
        if resource.save
          pre_registration.update!(used: true)
          sign_in(resource)
          redirect_to after_sign_up_path_for(resource), notice: 'Cadastro realizado com sucesso!'
        else
          clean_up_passwords resource
          set_minimum_password_length
          render :new, status: :unprocessable_entity
        end
      else
        self.resource = User.new(sign_up_params)
        flash.now[:alert] = "O e-mail ou CPF já está reservado."
        render :new, status: :unprocessable_entity
      end
    else
      super
    end
  end
  

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf, :first_name, :last_name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
