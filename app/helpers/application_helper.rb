module ApplicationHelper
  def avatar_src_for(user, size: 80)
    if user.respond_to?(:avatar) && user.avatar.present?
      url = user.avatar.url
      # キャッシュバスト（同名上書き対策）
      url = "#{url}?v=#{user.updated_at.to_i}" if user.respond_to?(:updated_at)
      url
    end
  end

  def avatar_image_tag(user, size: 40, **opts)
    src = avatar_src_for(user, size: size)
    classes = [ "rounded-full", opts.delete(:class) ].compact.join(" ")
    image_tag(src, width: size, height: size, class: classes, alt: user&.name, **opts)
  end
end
