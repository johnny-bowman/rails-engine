class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  has_one :merchant, through: :item
  has_many :transactions, through: :invoice
  has_many :customers, through: :invoice
end
