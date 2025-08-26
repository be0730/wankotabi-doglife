class BackfillUsersNameAndSetNotNull < ActiveRecord::Migration[8.0]
  def up
    # 既存のNULL/空文字を埋める（方針はお好みで。ここでは空文字に統一）
    execute "UPDATE users SET name = '' WHERE name IS NULL OR name = '';"

    # 必要ならデフォルトも設定（任意）
    change_column_default :users, :name, ""

    # NOT NULLを付与
    change_column_null :users, :name, false
  end

  def down
    change_column_null :users, :name, true
    change_column_default :users, :name, nil
  end
end
