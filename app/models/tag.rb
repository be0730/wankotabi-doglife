class Tag < ApplicationRecord
  has_many :facilities_tags, dependent: :destroy
  has_many :facilities, through: :facilities_tags

  validates :key,  presence: true, uniqueness: true
  validates :name, presence: true

  # アセット画像のパス（例: app/assets/images/tags/"ファイル名".svg）
  def icon_asset_path
    "tags/#{key}.svg"
  end
end
