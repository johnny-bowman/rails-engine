class Api::V1::Revenue::ItemsController < ApplicationController
  def index
    if params[:quantity]
      quantity = params[:quantity]
    else
      quantity = 10
    end
    render json: ItemRevenueSerializer.new(Item.desc_revenue(quantity))
  end
end
