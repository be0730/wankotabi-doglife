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

  def default_meta_tags
    {
      site:        "WankoTabi DogLife",
      title:       "わんこたび",
      reverse:     true,
      separator:   "|",
      description: "犬と一緒に行ける施設を検索・共有できるサービスです。",
      keywords:    %w[犬 犬連れ 旅行 お出かけ ドッグラン カフェ ホテル 施設 検索 共有],
      canonical:   request.original_url,
      noindex:     !Rails.env.production?,
      icon: [
        { href: image_url("favicon.ico") },
        { href: image_url("icon.png"), rel: "apple-touch-icon", sizes: "192x192", type: "image/png" }
      ],
      og: {
        site_name:   :site,
        title:       :title,
        type:        "website",
        url:         :canonical,
        description: :description,
        image:       image_url("ogp.png"),
        locale:      "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
