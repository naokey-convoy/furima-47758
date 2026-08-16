require 'rails_helper'

RSpec.describe Item, type: :model do
  describe '商品出品' do
    subject(:item) { FactoryBot.build(:item) }

    context '出品できる場合' do
      it 'すべての項目が正しく入力されていれば出品できる' do
        expect(item).to be_valid
      end

      it '価格が300円であれば出品できる' do
        item.price = 300
        expect(item).to be_valid
      end

      it '価格が9,999,999円であれば出品できる' do
        item.price = 9_999_999
        expect(item).to be_valid
      end
    end

    context '出品できない場合' do
      it '商品画像がなければ出品できない' do
        item.image = nil
        expect(item).not_to be_valid
      end

      it '商品名が空では出品できない' do
        item.name = ''
        expect(item).not_to be_valid
      end

      it '商品の説明が空では出品できない' do
        item.description = ''
        expect(item).not_to be_valid
      end

      it 'カテゴリーが未選択では出品できない' do
        item.category_id = 1
        expect(item).not_to be_valid
      end

      it '商品の状態が未選択では出品できない' do
        item.condition_id = 1
        expect(item).not_to be_valid
      end

      it '配送料の負担が未選択では出品できない' do
        item.shipping_fee_id = 1
        expect(item).not_to be_valid
      end

      it '発送元の地域が未選択では出品できない' do
        item.prefecture_id = 1
        expect(item).not_to be_valid
      end

      it '発送までの日数が未選択では出品できない' do
        item.shipping_day_id = 1
        expect(item).not_to be_valid
      end

      it '価格が空では出品できない' do
        item.price = nil
        expect(item).not_to be_valid
      end

      it '価格が299円以下では出品できない' do
        item.price = 299
        expect(item).not_to be_valid
      end

      it '価格が10,000,000円以上では出品できない' do
        item.price = 10_000_000
        expect(item).not_to be_valid
      end

      it '価格が全角数字では出品できない' do
        item.price = '３００'
        expect(item).not_to be_valid
      end

      it '価格に数字以外が含まれていると出品できない' do
        item.price = '300円'
        expect(item).not_to be_valid
      end

      it 'ユーザーが紐付いていなければ出品できない' do
        item.user = nil
        expect(item).not_to be_valid
      end
    end
  end
end
