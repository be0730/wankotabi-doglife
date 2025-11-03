require "open-uri"

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      info = request.env["omniauth.auth"]

      user = User.find_or_initialize_by(provider: info["provider"], uid: info["uid"])
      if user.new_record?
        # メール必須のアプリならメールで既存ユーザーをマージしてもOK
        user.email = info.dig("info", "email")
        user.name  = info.dig("info", "name") if user.respond_to?(:name)
        # パスワード不要で作るならランダムで
        user.password = Devise.friendly_token[0, 20]
      end

      # 画像添付：まだavatar未設定で、Googleから画像URLが来ていれば保存
      if user.avatar.blank?
        image_url = info.dig("info", "image") || info.dig("extra", "raw_info", "picture")
        if image_url.present?
          # サイズを強制したい場合（返ってくるクエリに応じて調整）
          image_url = image_url.gsub(/=s\d+-c$/, "=s256-c")
          image_url = image_url.sub(/\?sz=\d+/, "?sz=256") unless image_url.include?("sz=")

          begin
            file = URI.open(image_url)  # ネットワーク例外の可能性あり
            content_type = file.content_type.presence || "image/jpeg"
            user.avatar.attach(
              io: file,
              filename: "avatar-#{user.id}.jpg",
              content_type: content_type
            )
          rescue => e
            Rails.logger.warn("[OAuth Avatar] download failed: #{e.class} #{e.message}")
          end
        end
      end

      if user.save
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      else
        redirect_to new_user_session_path, alert: "Google ログインに失敗しました。"
      end
    end

    def failure
      redirect_to root_path, alert: "Google ログインに失敗しました。"
    end
  end
end
