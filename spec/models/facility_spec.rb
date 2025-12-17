require 'rails_helper'

RSpec.describe Facility, type: :model do
  describe 'バリデーションチェック' do
    it "titleが空欄の場合、バリデーションエラーになるか" do
      facility = Facility.new(title: "")
      facility.valid?
      expect(facility.errors[:title]).to include("を入力してください")
    end
    it "categoryが空欄の場合、バリデーションエラーになるか" do
      facility = Facility.new(category: "")
      facility.valid?
      expect(facility.errors[:category]).to include("を入力してください")
    end
    it "cityが空欄の場合、バリデーションエラーになるか" do
      facility = Facility.new(city: "")
      facility.valid?
      expect(facility.errors[:city]).to include("を入力してください")
    end
    it "streetが空欄の場合、バリデーションエラーになるか" do
      facility = Facility.new(street: "")
      facility.valid?
      expect(facility.errors[:street]).to include("を入力してください")
    end
  end
end
