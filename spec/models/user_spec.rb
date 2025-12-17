require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'バリデーションチェック' do
    it "nameが空欄の場合、バリデーションエラーになるか" do
      user = User.new(name: "")
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end
    it "nameが21文字以上の場合、バリデーションエラーになるか" do
      user = User.new(name: "a" * 21)
      user.valid?
      expect(user.errors[:name]).to include("は20文字以内で入力してください")
    end
    it "nameが重複している場合、バリデーションエラーになるか" do
      User.create!(name: "testuser", email: "test@example.com", password: "password")
      user = User.new(name: "testuser", email: "test2@example.com", password: "password")
      user.valid?
      expect(user.errors[:name]).to include("はすでに存在します")
    end
  end
end
