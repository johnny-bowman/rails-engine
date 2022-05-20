class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_by_name(name)
    find_by_sql("SELECT * FROM merchants WHERE LOWER(name) LIKE '%#{name.downcase}%'")
  end
end
