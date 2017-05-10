class Merchant
  attr_reader :id, :name

  def initialize(merchant_attributes)
    @id = merchant_attributes["id"]
    @name = merchant_attributes["name"]
  end

end
