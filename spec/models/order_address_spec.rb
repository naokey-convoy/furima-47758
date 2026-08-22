require "rails_helper"

RSpec.describe OrderAddress, type: :model do
  before(:context) do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item, user: @user)
  end

  before do
    @order_address = FactoryBot.build(:order_address, user_id: @user.id, item_id: @item.id)
  end

  after(:context) do
    @item.destroy!
    @user.destroy!
  end

  subject(:order_address) { @order_address }

  describe "商品購入情報の保存" do
    context "保存できる場合" do
      it "すべての項目が正しく入力されていれば保存できる" do
        expect(order_address).to be_valid
      end

      it "建物名が空でも保存できる" do
        order_address.building = ""

        expect(order_address).to be_valid
      end
    end

    context "保存できない場合" do
      it "tokenが空では保存できない" do
        order_address.token = nil

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Token can't be blank")
      end

      it "郵便番号が空では保存できない" do
        order_address.postal_code = ""

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Postal code can't be blank")
      end

      it "郵便番号にハイフンがなければ保存できない" do
        order_address.postal_code = "1234567"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Postal code is invalid")
      end

      it "郵便番号が全角数字では保存できない" do
        order_address.postal_code = "１２３-４５６７"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Postal code is invalid")
      end

      it "都道府県が未選択では保存できない" do
        order_address.prefecture_id = 1

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Prefecture can't be blank")
      end

      it "市区町村が空では保存できない" do
        order_address.city = ""

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("City can't be blank")
      end

      it "番地が空では保存できない" do
        order_address.street = ""

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Street can't be blank")
      end

      it "電話番号が空では保存できない" do
        order_address.phone = ""

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Phone can't be blank")
      end

      it "電話番号にハイフンが含まれていると保存できない" do
        order_address.phone = "090-1234-5678"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Phone is invalid")
      end

      it "電話番号が9桁以下では保存できない" do
        order_address.phone = "123456789"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Phone is invalid")
      end

      it "電話番号が12桁以上では保存できない" do
        order_address.phone = "090123456789"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Phone is invalid")
      end

      it "電話番号が全角数字では保存できない" do
        order_address.phone = "０９０１２３４５６７８"

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Phone is invalid")
      end

      it "user_idが空では保存できない" do
        order_address.user_id = nil

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("User can't be blank")
      end

      it "item_idが空では保存できない" do
        order_address.item_id = nil

        expect(order_address).not_to be_valid
        expect(order_address.errors.full_messages).to include("Item can't be blank")
      end
    end
  end
end
