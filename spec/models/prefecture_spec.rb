require 'rails_helper'

RSpec.describe Prefecture, type: :model do
  describe 'アソシエーションチェック' do
    it '施設が存在する場合は都道府県を削除できないこと' do
      expect(described_class)
        .to have_many(:facilities)
        .dependent(:restrict_with_exception)
    end
  end

  describe '検索属性チェック' do
    it '許可された属性のみ返すこと' do
      expect(described_class.ransackable_attributes)
        .to match_array %w[id code name created_at updated_at]
    end
  end

  describe '検索アソシエーションチェック' do
    it '許可されたアソシエーションのみ返すこと' do
      expect(described_class.ransackable_associations)
        .to match_array %w[facilities]
    end
  end
end
