class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :ensure_item_available

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)

    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def ensure_item_available
    redirect_to root_path if current_user == @item.user || @item.order.present?
  end

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :street, :building, :phone, :token)
          .merge(user_id: current_user.id, item_id: @item.id)
  end

  def pay_item
    Payjp.api_key = payjp_secret_key
    Payjp::Charge.create(amount: @item.price, card: order_params[:token], currency: "jpy")
  end

  def payjp_secret_key
    ENV["PAYJP_SECRET_KEY"].presence || Rails.application.credentials.dig(:payjp, :secret_key)
  end
end
