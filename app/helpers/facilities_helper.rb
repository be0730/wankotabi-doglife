module FacilitiesHelper
  def facility_confirm_fields
    %i[
      title category postal_code prefecture_id prefecture_name city street building
      latitude longitude overview phone_number business_hours closed_day
      homepage_url instagram_url facebook_url x_url supplement
    ]
  end

  def render_facility_rows(rows)
    safe_join(
      rows.map do |label, val|
        safe_val = val.is_a?(ActiveSupport::SafeBuffer) ? val : h(val.to_s)

        content_tag(:div, class: "grid grid-cols-[auto,1fr] gap-x-1 min-w-0") do
          content_tag(:span, "#{label}：", class: "font-normal shrink-0") +
            content_tag(
              :span,
              safe_val,
              class: "min-w-0 [overflow-wrap:anywhere] break-words whitespace-normal [&_a]:[overflow-wrap:anywhere] [&_a]:break-words [&_a]:whitespace-normal"
            )
        end
      end
    )
  end
end
