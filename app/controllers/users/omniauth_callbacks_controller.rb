require "open-uri"

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth  = request.env["omniauth.auth"]
      email = auth.dig("info", "email")

      # 1) provider/uid で探す → なければ email で既存ユーザーを拾って紐付け
      user = User.find_by(provider: auth["provider"], uid: auth["uid"]) ||
             User.find_by(email: email) ||
             User.new

      user.provider = auth["provider"]
      user.uid      = auth["uid"]

      user.email = email if user.email.blank?
      user.name  = auth.dig("info", "name") if user.respond_to?(:name) && user.name.blank?

      # password 必須バリデーションがある場合の保険
      if user.encrypted_password.blank?
        user.password = Devise.friendly_token[0, 20]
      end

      # confirmable を使っているなら必要に応じて
      user.skip_confirmation! if user.respond_to?(:skip_confirmation!) && user.confirmed_at.blank?

      attach_google_avatar!(user, auth)

      if user.save
        sign_in(user)
        redirect_to root_path, notice: "Googleでログインしました。"
      else
        Rails.logger.warn("[OAuth] save failed: #{user.errors.full_messages.join(', ')}")
        redirect_to new_user_session_path, alert: "Google ログインに失敗しました。入力内容をご確認ください。"
      end
    end

    def failure
      redirect_to new_user_session_path, alert: "Google ログインに失敗しました。"
    end

    private

    def attach_google_avatar!(user, auth)
      return if user.avatar.attached?

      image_url = auth.dig("info", "image") || auth.dig("extra", "raw_info", "picture")
      return if image_url.blank?

      # サイズ調整（来るURL形式に合わせて）
      image_url = image_url.gsub(/=s\d+-c$/, "=s256-c")
      image_url = image_url.sub(/\?sz=\d+/, "?sz=256") unless image_url.include?("sz=")

      file = URI.open(image_url)
      user.avatar.attach(
        io: file,
        filename: "avatar.jpg",
        content_type: file.content_type.presence || "image/jpeg"
      )
    rescue => e
      Rails.logger.warn("[OAuth Avatar] download failed: #{e.class} #{e.message}")
    end
  end
end
