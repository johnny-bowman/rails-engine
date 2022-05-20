require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it "returns all items for given merchant id" do
    merchant = create(:merchant)
    items = create_list(:item, 3, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    items_response = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    items_response.each do |item|
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

  it "finds merchant based on search params" do
    create_list(:merchant, 3)
    merchant_name = Merchant.all.first.name

    get "/api/v1/merchants/find?name=#{merchant_name.downcase}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
  end

  it "returns error object on search when no merchant matches" do
    get "/api/v1/merchants/find?name=cheesepuffmcgooberstein"

    error_response = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(error_response[:error]).to eq("Merchant not found")
  end
end
