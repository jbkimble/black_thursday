class Item
  attr_reader :id, :name, :description, :unit_price,
              :created_at, :updated_at, :merchant_id

  def initialize(row)
    @id = row["id"]
    @name = row["name"]
    @description = row["description"]
    @unit_price = row["unit_price"]
    @created_at = row["created_at"]
    @updated_at = row["updated_at"]
    @merchant_id = row["merchant_id"]

  end

  def unit_price_to_dollars
    unit_price.to_f
  end

  def merchant
    @name
  end
end
