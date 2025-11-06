class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :key,  null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :tags, :key, unique: true
  end
end
