module FacilitiesHelper
  def facility_confirm_fields
    %i[
      title category postal_code prefecture_id prefecture_name city street building
      latitude longitude overview phone_number business_hours closed_day
      homepage_url instagram_url facebook_url x_url supplement
    ]
  end

  def category_badge_classes(category)
    map = {
      "accommodation"  => "bg-green-100 text-green-800",
      "restaurant"  => "bg-amber-100 text-amber-800",
      "leisure" => "bg-blue-100 text-blue-800",
      "shop"  => "bg-purple-100 text-purple-800"
    }
    map.fetch(category.to_s, "bg-gray-100 text-gray-700")
  end
end
