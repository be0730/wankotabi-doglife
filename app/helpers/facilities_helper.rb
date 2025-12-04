module FacilitiesHelper
  def facility_confirm_fields
    %i[
      title category postal_code prefecture_id prefecture_name city street building
      latitude longitude overview phone_number business_hours closed_day
      homepage_url instagram_url facebook_url x_url supplement
    ]
  end

  def render_facility_rows(rows)
    safe_join(rows.map { |label, val|
      content_tag(:div, class: "flex gap-1") do
        content_tag(:span, "#{label}：", class: "font-normal") +
        content_tag(:span, val.to_s.html_safe)
      end
    })
  end
end
