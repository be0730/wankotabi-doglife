class AddPrefectureRefToFacilities < ActiveRecord::Migration[8.0]
  def change
    add_reference :facilities, :prefecture, null: false, foreign_key: true
  end
end
