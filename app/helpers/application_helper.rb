module ApplicationHelper
  def avatar_src_for(user, size: 80)
    return asset_path("avatar_placeholder.png") unless user

    if user.respond_to?(:avatar) &&
        user.avatar.respond_to?(:attached?) &&
        user.avatar.attached?
      variant = user.avatar.variant(resize_to_fill: [ size, size ]).processed
      return rails_representation_path(variant, only_path: true)
    end

    if user.respond_to?(:avatar) && user.avatar.present?
      url = user.avatar.url
      # キャッシュバスト（同名上書き対策）
      url = "#{url}?v=#{user.updated_at.to_i}" if user.respond_to?(:updated_at)
      url
    end

    asset_path("avatar_placeholder.png")
  end

  def avatar_image_tag(user, size: 40, **opts)
    src = avatar_src_for(user, size: size)
    classes = [ "rounded-full", opts.delete(:class) ].compact.join(" ")
    image_tag(src, width: size, height: size, class: classes, alt: user&.name, **opts)
  end
end
