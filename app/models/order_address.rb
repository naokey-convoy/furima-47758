class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :street, :building, :phone, :user_id, :item_id, :token

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }
    validates :city
    validates :street
    validates :user_id
    validates :item_id
    validates :token
  end

  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :phone, presence: true, format: { with: /\A\d{10,11}\z/ }

  def save
    ApplicationRecord.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      Address.create!(postal_code: postal_code, prefecture_id: prefecture_id, city: city,
                      street: street, building: building, phone: phone, order: order)
    end
  end
end
