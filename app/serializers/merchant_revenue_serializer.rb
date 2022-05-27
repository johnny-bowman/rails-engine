class MerchantRevenueSerializer
  include JSONAPI::Serializer
  
  attributes :revenue do |merchant|
    merchant.total_revenue
  end
end
