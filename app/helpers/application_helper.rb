# app/helpers/application_helper.rb
module ApplicationHelper
  def avatar_image_tag(user = nil, size: 32, **options)
    src =
      if user&.respond_to?(:avatar?) && user.avatar? # CarrierWave
        user.avatar.url
      elsif user&.respond_to?(:avatar) && user.avatar.respond_to?(:attached?) && user.avatar.attached? # ActiveStorage
        rails_blob_path(user.avatar, only_path: true)  # 相対パスでOK
      else
        asset_path("avatar_placeholder.png")           # 置き画像を用意
      end

    # size を "WxH" 形式に整えつつ、ビュー側の上書きも許容
    options[:size] ||= "#{size}x#{size}"
    options[:alt]  ||= (user&.name || "Guest")

    image_tag(src, **options)
  end
end
