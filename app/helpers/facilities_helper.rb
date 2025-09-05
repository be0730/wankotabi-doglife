module FacilitiesHelper
  def facility_confirm_fields
    %i[
      title category postal_code prefecture_id prefecture_name city street building
      latitude longitude overview phone_number business_hours closed_day
      homepage_url instagram_url facebook_url x_url supplement
    ]
  end
end
