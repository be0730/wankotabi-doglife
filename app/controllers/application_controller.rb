class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  add_flash_types :success, :danger

  def require_login
    return if current_user

    flash[:danger] = "Googleログインが必要です"
    redirect_to root_path
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: [ :name, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar, :remove_avatar ])
  end

  def after_sending_reset_password_instructions_path_for(_resource_name)
    password_sent_path
  end

  private

  def not_authenticated
    redirect_to root_path
  end
end
