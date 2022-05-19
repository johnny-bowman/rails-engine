require 'rails_helper'

RSpec.describe Transaction do
  describe "relationships" do
    it { should belong_to(:invoice) }
    it { should have_many(:customers).through(:invoice) }
    it { should have_many(:merchants).through(:invoice) }
    it { should have_many(:invoice_items).through(:invoice) }
    it { should have_many(:items).through(:invoice_items) }
  end
end
