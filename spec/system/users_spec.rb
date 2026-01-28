require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_registration_path
          fill_in 'user[name]', with: 'テストユーザー'
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content 'ようこそ！登録が完了しました。'
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end

      context 'ユーザー名が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'user[name]', with: ''
          fill_in 'user[email]', with: 'email@example.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content '1件のエラーによりこのユーザーは保存されませんでした'
          expect(page).to have_content 'ユーザー名を入力してください'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_registration_path
          fill_in 'user[name]', with: 'テストユーザー'
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content '1件のエラーによりこのユーザーは保存されませんでした'
          expect(page).to have_content 'メールアドレスを入力してください'
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_registration_path
          fill_in 'user[name]', with: 'テストユーザー'
          fill_in 'user[email]', with: existed_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '登録する'
          expect(page).to have_content '1件のエラーによりこのユーザーは保存されませんでした'
          expect(page).to have_content 'メールアドレス登録失敗しました。入力内容をご確認ください。'
          expect(page).to have_field 'user[email]', with: existed_user.email
        end
      end
    end

    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(user)
          expect(page).to have_current_path new_user_session_path, ignore_query: true
          expect(page).to have_content 'メールアドレス'
          expect(page).to have_content 'パスワード'
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_registration_path
          fill_in 'user[name]', with: 'update_user'
          fill_in 'user[email]', with: 'update@example.com'
          fill_in 'user[password]', with: 'update_password'
          fill_in 'user[password_confirmation]', with: 'update_password'
          click_button '更新'
          expect(page).to have_content 'アカウント情報を更新しました。'
          expect(page).to have_current_path root_path, ignore_query: true
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path(user)
          fill_in 'user[email]', with: ''
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '更新'
          expect(page).to have_content('1件のエラーによりこのユーザーは保存されませんでした')
          expect(page).to have_content("メールアドレスを入力してください")
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_registration_path(user)
          other_user = create(:user)
          fill_in 'user[email]', with: other_user.email
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button '更新'
          expect(page).to have_content('1件のエラーによりこのユーザーは保存されませんでした')
          expect(page).to have_content('メールアドレス登録失敗しました。入力内容をご確認ください。')
        end
      end
    end
  end
end
