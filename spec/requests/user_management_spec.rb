# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ユーザー管理", type: :request do
  let(:user_attributes) { attributes_for(:user) }

  describe "新規登録" do
    it "正しい情報でユーザーを登録できる" do
      expect do
        post user_registration_path, params: { user: user_attributes }
      end.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
    end

    it "不正な情報では登録せず、エラーと入力済み情報を表示する" do
      invalid_attributes = user_attributes.merge(nickname: "入力済み", password: "")

      expect do
        post user_registration_path, params: { user: invalid_attributes }
      end.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("入力済み")
      expect(response.body).to include("error_explanation")
    end
  end

  describe "ログイン・ログアウト" do
    let!(:user) { create(:user) }

    it "正しい情報でログインできる" do
      post user_session_path, params: { user: { email: user.email, password: user.password } }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include(user.nickname)
      expect(response.body).to include("ログアウト")
    end

    it "不正な情報ではログインせず、エラーを表示する" do
      post user_session_path, params: { user: { email: user.email, password: "wrong123" } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Invalid email or password")
      expect(response.body).to include(user.email)
    end

    it "ログイン後にログアウトできる" do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("新規登録")
      expect(response.body).to include("ログイン")
    end
  end
end
