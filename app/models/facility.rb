class Facility < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture, optional: false
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :images

  enum :category, {
    accommodation: 0, # 宿泊施設
    restaurant:    1, # 飲食店
    leisure:       2, # レジャー施設
    shop:          3  # ショップ
  }, prefix: :true

  validates :title, :category, :prefecture_id, :city, :street, presence: true

  def full_address
    [ prefecture.name, city, street, building ].compact.join
  end

  ransack_alias :full_address, :prefecture_name_or_city_or_street_or_building
  ransack_alias :keyword, :title_or_full_address

  def self.ransackable_attributes(_ = nil)
    %w[
      title category postal_code prefecture_id city street building
      latitude longitude overview phone_number business_hours closed_day
      homepage_url instagram_url facebook_url x_url created_at updated_at
      full_address keyword
    ]
  end

  def self.ransackable_associations(_ = nil)
    %w[user prefecture]
  end

  # geocoder を使うなら（住所変更時のみジオコーディング）
  # geocoded_by :full_address
  # after_validation :geocode, if: :will_save_change_to_full_address?

  # geocoder を使うなら（住所変更時にジオコーディング）
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.full_address    = geo.address
      obj.postal_code     = geo.postal_code
      obj.prefecture_code = geo.state_code
      obj.prefecture_name = geo.state
      obj.city            = geo.city
      obj.street          = geo.street
      obj.building        = geo.sub_state
    end
  end
  after_validation :reverse_geocode, if: :will_save_change_to_latitude_or_longitude?
end
