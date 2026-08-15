require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー新規登録' do
    subject(:user) { FactoryBot.build(:user) }

    context '登録できる場合' do
      it 'すべての項目が正しく入力されていれば登録できる' do
        expect(user).to be_valid
      end
    end

    context '登録できない場合' do
      it 'nicknameが空では登録できない' do
        user.nickname = ''
        expect(user).not_to be_valid
      end

      it 'emailが空では登録できない' do
        user.email = ''
        expect(user).not_to be_valid
      end

      it 'emailに@が含まれていなければ登録できない' do
        user.email = 'testexample.com'
        expect(user).not_to be_valid
      end

      it '重複したemailでは登録できない' do
        FactoryBot.create(:user, email: user.email)
        expect(user).not_to be_valid
      end

      it 'passwordが空では登録できない' do
        user.password = ''
        user.password_confirmation = ''
        expect(user).not_to be_valid
      end

      it 'passwordが5文字以下では登録できない' do
        user.password = 'ab123'
        user.password_confirmation = 'ab123'
        expect(user).not_to be_valid
      end

      it 'passwordが英字のみでは登録できない' do
        user.password = 'abcdef'
        user.password_confirmation = 'abcdef'
        expect(user).not_to be_valid
      end

      it 'passwordが数字のみでは登録できない' do
        user.password = '123456'
        user.password_confirmation = '123456'
        expect(user).not_to be_valid
      end

      it 'passwordに全角文字が含まれると登録できない' do
        user.password = 'ａｂｃ123'
        user.password_confirmation = 'ａｂｃ123'
        expect(user).not_to be_valid
      end

      it 'passwordとpassword_confirmationが一致しなければ登録できない' do
        user.password_confirmation = 'abc456'
        expect(user).not_to be_valid
      end

      it 'last_nameが空では登録できない' do
        user.last_name = ''
        expect(user).not_to be_valid
      end

      it 'last_nameが半角では登録できない' do
        user.last_name = 'Yamada'
        expect(user).not_to be_valid
      end

      it 'first_nameが空では登録できない' do
        user.first_name = ''
        expect(user).not_to be_valid
      end

      it 'first_nameが半角では登録できない' do
        user.first_name = 'Taro'
        expect(user).not_to be_valid
      end

      it 'last_name_kanaが空では登録できない' do
        user.last_name_kana = ''
        expect(user).not_to be_valid
      end

      it 'last_name_kanaが全角カタカナ以外では登録できない' do
        user.last_name_kana = 'やまだ'
        expect(user).not_to be_valid
      end

      it 'first_name_kanaが空では登録できない' do
        user.first_name_kana = ''
        expect(user).not_to be_valid
      end

      it 'first_name_kanaが全角カタカナ以外では登録できない' do
        user.first_name_kana = 'たろう'
        expect(user).not_to be_valid
      end

      it 'birth_dateが空では登録できない' do
        user.birth_date = nil
        expect(user).not_to be_valid
      end
    end
  end
end
