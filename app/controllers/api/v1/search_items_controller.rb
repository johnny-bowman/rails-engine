class Api::V1::SearchItemsController < ApplicationController
  def index
    if params[:name]
      items = Item.search_by_name(params[:name])
    elsif params[:min_price] && params[:max_price]
      items = Item.search_by_price_range(params[:max_price], params[:min_price])
    elsif params[:min_price] && !params[:max_price]
      items = Item.search_by_min_price(params[:min_price])
    elsif params[:max_price] && !params[:min_price]
      items = Item.search_by_max_price(params[:max_price])
    end

    if !items.empty?
      items.each do |item|
        render json: ItemSerializer.new(item)
      end
    else
      render json: {data: {error: 'Items not found'}}
    end
    # binding.pry
  end
end
