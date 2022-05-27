class Api::V1::SearchItemsController < ApplicationController
  def index
    if params[:name]
      items = Item.search_by_name(params[:name])
    elsif params[:min_price] && params[:max_price]
      items = Item.search_by_price_range(params[:max_price], params[:min_price])
    end

    if !items.empty?
      render json: ItemSerializer.new(items)
    else
      render json: {data: {error: 'Items not found'}}, status: :not_found
    end
  end
end
