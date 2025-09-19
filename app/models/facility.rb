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

  validates :title, :category, :city, :street, presence: true

  delegate :name, to: :prefecture, prefix: true, allow_nil: true

  def full_address
    [ prefecture_name, city.presence, street.presence, building.presence ].compact.join
  end

  ransack_alias :full_address, :prefecture_name_or_city_or_street_or_building
  ransack_alias :keyword,      :title_or_prefecture_name_or_city_or_street_or_building

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

  geocoded_by :full_address
  after_validation :geocode, if: :should_geocode?

  private

  def should_geocode?
    address_parts_changed? && !full_address.blank?
  end

  def address_parts_changed?
    will_save_change_to_postal_code? ||
    will_save_change_to_prefecture_id? ||
    will_save_change_to_city? ||
    will_save_change_to_street? ||
    will_save_change_to_building?
  end
end
