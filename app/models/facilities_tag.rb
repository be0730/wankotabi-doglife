class FacilitiesTag < ApplicationRecord
  belongs_to :facility
  belongs_to :tag

  validates :facility_id, uniqueness: { scope: :tag_id }
end
