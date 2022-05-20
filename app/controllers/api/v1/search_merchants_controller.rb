class Api::V1::SearchMerchantsController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])
  
    if !merchant.empty?
      render json: MerchantSerializer.new(merchant.first)
    else
      render json: {data: {error: 'Merchant not found'}}
    end
  end
end
