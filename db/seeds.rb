# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

pref_names = %w[
  北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県 茨城県 栃木県 群馬県
  埼玉県 千葉県 東京都 神奈川県 新潟県 富山県 石川県 福井県 山梨県 長野県
  岐阜県 静岡県 愛知県 三重県 滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県
  鳥取県 島根県 岡山県 広島県 山口県 徳島県 香川県 愛媛県 高知県
  福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県 沖縄県
]

pref_names.each_with_index do |name, i|
  Prefecture.find_or_create_by!(code: i + 1) do |p|
    p.name = name
  end
end
puts "Seeded #{Prefecture.count} prefectures"

fixed = [
  { key: "small_ok",  name: "小型犬OK" },
  { key: "medium_ok", name: "中型犬OK" },
  { key: "large_ok",  name: "大型犬OK" },
  { key: "multi_ok",  name: "多頭OK"   },
  { key: "indoor_ok", name: "室内OK"  }
]
fixed.each do |h|
  Tag.find_or_create_by!(key: h[:key]) do |t|
    t.name = h[:name]
  end
end
