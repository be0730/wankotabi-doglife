class Users::PasswordsController < Devise::PasswordsController
  protected

  # パスワード再設定完了後のリダイレクト先をログイン画面にする
  def after_resetting_password_path_for(resource)
    new_session_path(resource_name)
  end
end
