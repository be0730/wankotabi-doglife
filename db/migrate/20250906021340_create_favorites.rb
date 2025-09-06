class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :facility, foreign_key: true

      t.timestamps
    end
    add_index :favorites, [:user_id, :facility_id], unique: true
  end
end
