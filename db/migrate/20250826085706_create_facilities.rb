class CreateFacilities < ActiveRecord::Migration[8.0]
  def change
    create_table :facilities do |t|
      t.references :user, null: false, foreign_key: true

      t.string :title, null: false
      t.integer :category, null: false, default: 0
      t.text :overview
      t.string :full_address
      t.string :postal_code
      t.string :prefecture_code
      t.string :prefecture_name
      t.string :city
      t.string :street
      t.string :building
      t.decimal :latitude
      t.decimal :longitude
      t.string :phone_number
      t.string :business_hours
      t.string :closed_day
      t.string :homepage_url
      t.string :instagram_url
      t.string :facebook_url
      t.string :X_url
      t.string :supplement

      t.timestamps null: false
    end
    add_index :facilities, :category
    add_index :facilities, :prefecture_code
    add_index :facilities, [:latitude, :longitude]
  end
end
