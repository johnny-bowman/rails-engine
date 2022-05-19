require "rails_helper"

RSpec.describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 3)

    get "/api/v1/items"
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it "sends one item" do
    id = create(:item).id

    get "/api/v1/items/#{id}"
    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end

  it "creates an item" do
    merchant = create(:merchant)
     item_params = ({
       name: "Cam",
       description: "Don't die, use this!",
       unit_price: 204.40,
       merchant_id: merchant.id
     })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    created_item = Item.last

    expect(response.status).to eq(201)
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "edits an item" do
    id = create(:item).id
    previous_name = (Item.last).name
    item_params = { name: "Chizzity Chair" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Chizzity Chair")
  end

  it "returns 404 error when updating item with bad merchant_id" do
    original_item = create(:item)
    bad_merch_id = original_item.merchant_id + 1

    item_params = { merchant_id: bad_merch_id }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{original_item.id}", headers: headers, params: JSON.generate(item: item_params)
    new_item = Item.find_by(id: original_item.id)

    expect(response.status).to eq(404)

    expect(new_item.merchant_id).to eq(original_item.merchant_id)

    expect(original_item.name) eq(new_item.name)
  end
end
