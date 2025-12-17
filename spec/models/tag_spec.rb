require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'バリデーションチェック' do
    it "keyが空欄の場合、バリデーションエラーになるか" do
      tag = Tag.new(key: "")
      tag.valid?
      expect(tag.errors[:key]).to include("を入力してください")
    end
    it "keyが重複している場合、バリデーションエラーになるか" do
      Tag.create!(key: "accommodation", name: "宿泊施設")
      tag = Tag.new(key: "accommodation", name: "宿泊施設")
      tag.valid?
      expect(tag.errors[:key]).to include("はすでに存在します")
    end
    it "nameが空欄の場合、バリデーションエラーになるか" do
      tag = Tag.new(name: "")
      tag.valid?
      expect(tag.errors[:name]).to include("を入力してください")
    end
  end
end
