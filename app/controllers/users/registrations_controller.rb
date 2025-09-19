class Users::RegistrationsController < Devise::RegistrationsController
  # Active Storage の削除チェック対応
  def update
    if params.dig(:user, :remove_avatar) == "1"
      resource.avatar.purge_later if resource.avatar_attachment&.attached?
    end
    super
  end
end
