class MerchantSerializer
  def initialize(merchants)
    @merchants = merchants
  end

  def data_hash
    {
      "data":
      @merchants.map do |m|
        {
          "id": "#{m.id}",
          "type": "merchant",
          "attributes": {
            "name": "#{m.name}",
          }
        }
      end
    }
  end
end
