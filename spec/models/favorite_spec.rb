require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:facility) }
  end

  describe 'validations' do
    let(:user)     { create(:user) }
    let(:facility) { create(:facility) }

    subject { create(:favorite, user: user, facility: facility) }

    it do
      is_expected.
        to validate_uniqueness_of(:user_id).
        scoped_to(:facility_id)
    end
  end
end
