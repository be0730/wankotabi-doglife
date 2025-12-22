require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment) }

  describe 'アソシエーションチェック' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:facility) }
  end

  describe 'バリデーションチェック' do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:body).is_at_most(2000) }
  end
end
