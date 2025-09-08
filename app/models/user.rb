class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { maximum: 20 }

  has_many :facilities, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_facilities, through: :favorites, source: :facility

  def favorite(facility)
    favorites.find_or_create_by!(facility: facility)
  end

  def unfavorite?(facility)
    if (fav = favorites.find_by(facility: facility))
      fav.destroy
      true
    else
      false
    end
  end

  def favorite?(facility)
    favorites.exists?(facility_id: facility.id)
  end
end
