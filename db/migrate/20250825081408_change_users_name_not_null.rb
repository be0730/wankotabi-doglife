class ChangeUsersNameNotNull < ActiveRecord::Migration[8.0]
  def up
    # 既存の NULL を空文字で埋める（好みでデフォルト名でもOK）
    execute "UPDATE users SET name = '' WHERE name IS NULL;"

    # デフォルトを設定（任意だが NOT NULL にするなら併用が安全）
    change_column_default :users, :name, ""

    # NOT NULL 制約を付与
    change_column_null :users, :name, false
  end

  def down
    change_column_null :users, :name, true
    change_column_default :users, :name, nil
  end
end
