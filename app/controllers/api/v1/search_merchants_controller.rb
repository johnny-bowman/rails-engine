class Api::V1::SearchMerchantsController < ApplicationController
  def show
    binding.pry
    render json: MerchantSerializer.new(Merchant.search_by_name(params[:name]))
  end
end
