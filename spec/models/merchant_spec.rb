require 'rails_helper'

RSpec.describe Merchant do
  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe "class methods" do
    it "searches for merchants by name" do
      create_list(:merchant, 3)
      merchant = Merchant.all.first

      expect(Merchant.search_by_name(merchant.name)).to eq([merchant])
    end
  end
end
