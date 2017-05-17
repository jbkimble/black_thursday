require 'bigdecimal'
require 'time'
class Item
  attr_reader :id, :name, :description, :unit_price,
              :created_at, :updated_at, :merchant_id
              :se_instance

  def initialize(row, se_instance)
    @id = row["id"].to_i
    @name = row["name"]
    @description = row["description"].delete("\r")
    @unit_price = BigDecimal.new(row["unit_price"].split("").insert(-3, ".").join)
    @created_at = Time.parse(row["created_at"])
    @updated_at = Time.parse(row["updated_at"])
    @merchant_id = row["merchant_id"].to_i
    @se_instance = se_instance
  end

  def unit_price_to_dollars
    unit_price.to_f
  end

  def merchant
    merchant = @se_instance.merchants.find_by_id(merchant_id)
      return merchant
  end
end
