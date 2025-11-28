class FacilityPresenter
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def initialize(facility, view_context:)
    @f = facility
    @view = view_context
  end

  # index / show で出す項目を切替
  def rows(context:)
    keys =
      case context.to_sym
      when :index
        %i[postal_code address]
      else # :show デフォルト
        %i[
          overview
          postal_code
          address
          phone_number
          business_hours
          closed_days
          homepage_url
          instagram_url
          facebook_url
          x_url
          supplement
        ]
      end

    keys.filter_map { |k|
      v = value_for(k)
      next if v.blank?
      [label_for(k), v]
    }
  end

  private

  def label_for(key)
    I18n.t("facilities.labels.#{key}", default: default_label(key))
  end

  def default_label(key)
    {
      postal_code: "〒",
      address: "住所",
      overview: "概要",
      phone_number: "電話番号",
      business_hours: "営業時間",
      closed_days: "定休日",
      homepage_url: "公式ホームページ",
      instagram_url: "公式Instagram",
      facebook_url: "公式Facebook",
      x_url: "公式X",
      supplement: "補足"
    }[key] || key.to_s.humanize
  end

  def value_for(key)
    case key

    when :address
      if @f.respond_to?(:full_address)
        @f.full_address.presence
      else
        [
          @f.try(:prefecture)&.name || @f.try(:prefecture_name),
          @f.city, @f.street, @f.building
        ].compact_blank.join.presence
      end

    when :phone_number
      num = @f.try(:phone_number)
      num.present? ? @view.link_to(num, "tel:#{num}") : nil

    when :homepage_url, :instagram_url, :facebook_url, :x_url
      url = @f.try(key)
      url.present? ? @view.link_to(url, url, target: "_blank", rel: "noopener") : nil

    else
      @f.try(key).presence
    end
  end
end
