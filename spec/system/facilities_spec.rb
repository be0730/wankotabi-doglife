require 'rails_helper'

RSpec.describe "Facilities", type: :system do
  let(:user) { create(:user) }
  let(:facility) { create(:facility, user: user) }
  let!(:prefecture) { Prefecture.find_by!(code: 13) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context '施設投稿ページへアクセス' do
        it '施設投稿ページへのアクセスが失敗する' do
          visit new_facility_path
          expect(page).to have_current_path new_user_session_path, ignore_query: true
          expect(page).to have_content 'メールアドレス'
          expect(page).to have_content 'パスワード'
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe '施設投稿' do
      context 'フォームの入力値が正常' do
        it '施設の新規投稿が成功する' do
          visit new_facility_path
          fill_in 'facility[title]', with: 'テスト施設'
          choose '飲食店'
          select '東京都', from: 'facility_prefecture_id'
          fill_in 'facility[city]', with: '渋谷区'
          fill_in 'facility[street]', with: '1-2-3'
          click_button '登録する'
          expect(page).to have_content '施設を投稿しました。'
          expect(page).to have_current_path facility_path(Facility.last), ignore_query: true
        end
      end
      context '都道府県が未選択' do
        it '施設の新規投稿が失敗する' do
          visit new_facility_path
          fill_in 'facility[title]', with: 'テスト施設'
          choose '飲食店'
          fill_in 'facility[city]', with: '渋谷区'
          fill_in 'facility[street]', with: '1-2-3'
          click_button '登録する'
          expect(page).to have_content '1件のエラーによりこの施設は保存されませんでした'
          expect(page).to have_content '都道府県を入力してください'
        end
      end
    end
    describe '施設編集' do
      context '編集内容が正常' do
        it '施設の編集が成功する' do
          visit edit_facility_path(facility)
          expect(page).to have_current_path(edit_facility_path(facility), ignore_query: true)
          fill_in 'facility_title', with: '更新後のテスト施設'
          click_button '更新する'
          expect(page).to have_content '施設を更新しました。'
          expect(page).to have_current_path facility_path(facility), ignore_query: true
        end
      end
    end
  end
end
