class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :facility

  validates :body, presence: true, length: { maximum: 2000 }
end
