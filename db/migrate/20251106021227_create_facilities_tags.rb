class CreateFacilitiesTags < ActiveRecord::Migration[8.0]
  def change
    create_table :facilities_tags do |t|
      t.references :facility, null: false, foreign_key: { on_delete: :cascade }
      t.references :tag,      null: false, foreign_key: { on_delete: :cascade }
    end
    add_index :facilities_tags, [ :facility_id, :tag_id ], unique: true
  end
end
