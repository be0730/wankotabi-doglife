class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    info = request.env['omniauth.auth']

    user = User.find_or_initialize_by(provider: info['provider'], uid: info['uid'])
    if user.new_record?
      # メール必須のアプリならメールで既存ユーザーをマージしてもOK
      user.email = info.dig('info', 'email')
      user.name  = info.dig('info', 'name') if user.respond_to?(:name)
      # パスワード不要で作るならランダムで
      user.password = Devise.friendly_token[0, 20]
    end

    if user.save
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      redirect_to new_user_session_path, alert: 'Google ログインに失敗しました。'
    end
  end

  def failure
    redirect_to root_path, alert: 'Google ログインに失敗しました。'
  end
end
