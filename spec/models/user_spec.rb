require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションチェック' do
    let(:user) { build(:user) }

    it "nameが空欄の場合、バリデーションエラーになるか" do
      user.name = ""
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end
    it "nameが21文字以上の場合、バリデーションエラーになるか" do
      user.name = "a" * 21
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end
    it "nameが重複している場合、バリデーションエラーになるか" do
      create(:user, name: "testuser")
      another_user = build(:user, name: "testuser")
      expect(another_user).to be_invalid
      expect(another_user.errors[:name]).to include("はすでに存在します")
    end
  end
end
