class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_by_name(name)
    find_by_sql("SELECT * FROM items WHERE LOWER(name) LIKE '%#{name.downcase}%'")
  end

  def self.search_by_min_price(price)
    where("unit_price >= #{price.to_i}")
  end

  def self.search_by_max_price(price)
    where("unit_price <= #{price.to_i}")
  end

  def self.search_by_price_range(price_1, price_2)
    if price_1 > price_2
      max_price = price_1
      min_price = price_2
    else
      max_price = price_2
      min_price = price_1
    end
    where(unit_price: (min_price.to_i)..(max_price.to_i))
  end

  def self.desc_revenue(quantity)
    select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoice_items: [:invoice, :transactions])
    .group(:id)
    .where(transactions: {result: "success"}, invoices: {status: "shipped"})
    .order(revenue: :desc)
    .limit(quantity)
  end
end
