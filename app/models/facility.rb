class Facility < ApplicationRecord
  belongs_to :user

  enum category: {
    accommodation: 0, # 宿泊施設
    restaurant:    1, # 飲食店
    leisure:       2, # レジャー施設
    shop:          3  # ショップ
  }, _prefix: true

  validates :title, :category, :prefecture_code, :city, :street, presence: true

  # geocoder を使うなら（住所変更時のみジオコーディング）
  # geocoded_by :full_address
  # after_validation :geocode, if: :will_save_change_to_full_address?

  # geocoder を使うなら（住所変更時にジオコーディング）
  # reverse_geocoded_by :latitude, :longitude do |obj, results|
  #   if geo = results.first
  #     obj.full_address    = geo.address
  #     obj.postal_code     = geo.postal_code
  #     obj.prefecture_code = geo.state_code
  #     obj.prefecture_name = geo.state
  #     obj.city            = geo.city
  #     obj.street          = geo.street
  #     obj.building        = geo.sub_state
  #   end
  # end
  # after_validation :reverse_geocode, if: :will_save_change_to_latitude_or_longitude?


  def full_address
    [ prefecture_name, city, street, building ].compact.join
  end
end
