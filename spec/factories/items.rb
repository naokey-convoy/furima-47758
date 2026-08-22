FactoryBot.define do
  factory :item do
    name { 'テスト商品' }
    description { '商品の説明です' }
    category_id { 2 }
    condition_id { 2 }
    shipping_fee_id { 2 }
    prefecture_id { 2 }
    shipping_day_id { 2 }
    price { 300 }
    association :user

    after(:build) do |item|
      item.image.attach(
        io: File.open(Rails.root.join('public/apple-touch-icon.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end
  end
end
