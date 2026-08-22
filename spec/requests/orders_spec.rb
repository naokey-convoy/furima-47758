require "rails_helper"

RSpec.describe "商品購入", type: :request do
  let(:seller) { FactoryBot.create(:user) }
  let(:buyer) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item, user: seller) }

  describe "GET /items/:item_id/orders" do
    context "ログインしている場合" do
      context "自身が出品していない販売中商品へアクセスした場合" do
        before do
          sign_in_as(buyer)
        end

        it "購入ページが表示される" do
          get item_orders_path(item)

          expect(response).to have_http_status(:ok)
        end
      end

      context "自身が出品していない売却済み商品へアクセスした場合" do
        before do
          Order.create!(user: buyer, item: item)
          sign_in_as(buyer)
        end

        it "トップページへ遷移する" do
          get item_orders_path(item)

          expect(response).to redirect_to(root_path)
        end
      end

      context "自身が出品した商品へアクセスした場合" do
        before do
          sign_in_as(seller)
        end

        it "販売中でもトップページへ遷移する" do
          get item_orders_path(item)

          expect(response).to redirect_to(root_path)
        end

        it "売却済みでもトップページへ遷移する" do
          Order.create!(user: buyer, item: item)

          get item_orders_path(item)

          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "ログアウトしている場合" do
      it "販売状況に関わらずログインページへ遷移する" do
        get item_orders_path(item)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  def sign_in_as(user)
    post user_session_path, params: { user: { email: user.email, password: user.password } }
  end
end
