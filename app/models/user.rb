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
    favorite_facilities << facility
  end

  def unfavorite?(facility)
    favorite_facilities.destroy(facility)
  end

  def favorite?(facility)
    favorite_facilities.include?(facility)
  end
end