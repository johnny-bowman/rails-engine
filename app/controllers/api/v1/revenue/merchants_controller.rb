class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    if params[:quantity]
      render json: MerchantNameRevenueSerializer.new(Merchant.top_merchants_by_revenue(params[:quantity]))
    else
      render json: {data: {error: 'Must have quantity param'}}, status: :bad_request
    end
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantRevenueSerializer.new(merchant)
  end
end
