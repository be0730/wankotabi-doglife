# db/migrate/xxxxxxxxxxxxxx_rename_facilities_x_url_to_x_url.rb
class RenameFacilitiesXUrlToXUrl < ActiveRecord::Migration[8.0]
  def change
    # 大文字カラムなのでシンボルをクォートして明示
    rename_column :facilities, :"X_url", :x_url
  end
end
