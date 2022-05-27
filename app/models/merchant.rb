class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_by_name(name)
    find_by_sql("SELECT * FROM merchants WHERE LOWER(name) LIKE '%#{name.downcase}%'")
  end

  def self.desc_revenue
    invoice_items.joins(:transactions)
      .where("transaction.result = success" )
      .group
  end

  def self.top_merchants_by_revenue(quantity)
      select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .joins(invoices: [:invoice_items, :transactions])
      .group(:id)
      .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
      .order(revenue: :desc)
      .limit(quantity)
  end

  def total_revenue
    invoices
    .joins(:invoice_items, :transactions)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .sum('(invoice_items.quantity * invoice_items.unit_price)')
  end
end
