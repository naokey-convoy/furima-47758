class User < ApplicationRecord
  has_many :items, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  with_options presence: true do
    validates :nickname
    validates :last_name, :first_name,
              format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: "は全角で入力してください" }
    validates :last_name_kana, :first_name_kana,
              format: { with: /\A[ァ-ヶー]+\z/, message: "は全角カタカナで入力してください" }
    validates :birth_date
  end

  validates :password,
            format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i,
                      message: "は半角英字と数字の両方を含めてください" },
            if: :password_required?
end
