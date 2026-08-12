FactoryBot.define do
  factory :user do
    nickname { 'テスト太郎' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'abc123' }
    password_confirmation { password }
    last_name { '山田' }
    first_name { '太郎' }
    last_name_kana { 'ヤマダ' }
    first_name_kana { 'タロウ' }
    birth_date { Date.new(1990, 1, 1) }
  end
end
