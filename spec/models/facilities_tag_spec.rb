require 'rails_helper'

RSpec.describe FacilitiesTag, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to belong_to(:facility) }
  end

  describe 'validations' do
    subject { build(:facilities_tag) }

    it do
      is_expected
        .to validate_uniqueness_of(:facility_id)
        .scoped_to(:tag_id)
    end
  end
end
