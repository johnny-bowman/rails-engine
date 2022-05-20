require 'rails_helper'

RSpec.describe Item do
  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "class methods" do
    it "searches for items by name" do
      item_1 = create(:item, name: 'My Couch', unit_price: '500')
      item_2 = create(:item, name: 'BandAid fix ouch', unit_price: '2')
      item_3 = create(:item, name: 'Turnips', unit_price: '10')

      expect(Item.search_by_name('ouch')).to eq([item_1, item_2])
    end

    it "searches for items by min price" do
      item_1 = create(:item, name: 'My Couch', unit_price: '500')
      item_2 = create(:item, name: 'BandAid fix ouch', unit_price: '2')
      item_3 = create(:item, name: 'Turnips', unit_price: '10')

      expect(Item.search_by_min_price('10')).to eq([item_1, item_3])
    end

    it "searches for items by max price" do
      item_1 = create(:item, name: 'My Couch', unit_price: '500')
      item_2 = create(:item, name: 'BandAid fix ouch', unit_price: '2')
      item_3 = create(:item, name: 'Turnips', unit_price: '10')

      expect(Item.search_by_max_price('499')).to eq([item_2, item_3])
    end

    it "searches for items with min and max price" do
      item_1 = create(:item, name: 'My Couch', unit_price: '500')
      item_2 = create(:item, name: 'BandAid fix ouch', unit_price: '2')
      item_3 = create(:item, name: 'Turnips', unit_price: '10')
      item_4 = create(:item, name: 'cheese puffs', unit_price: '300')

      expect(Item.search_by_price_range('10', '301')).to eq([item_3, item_4])
    end
  end
end
