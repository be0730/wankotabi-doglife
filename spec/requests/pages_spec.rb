require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "使い方ページへのリンクチェック" do
    it "使い方ページへアクセスできること" do
      get "/how_to_use"
      expect(response).to have_http_status(:success)
    end
  end
end
