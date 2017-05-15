class Customer
  attr_reader :id, :first_name, :last_name, :created_at,
              :updated_at, :se_instance

  def initialize(row, se_instance)
    @id = row["id"]
    @first_name = row["first_name"]
    @last_name = row["last_name"]
    @created_at = row["created_at"]
    @updated_at = row["updated_at"]
    @se_instance = se_instance
  end

  def merchants
    invoices = []
      @se_instance.invoices.all.each do |invoice|
        invoices << invoice if invoice.customer_id == id
      end
    merchant_ids = []
      invoices.each do |invoice|
        merchant_ids << invoice.merchant_id
      end
      x = @se_instance.merchants.all.each.select do |merchant|
        merchant_ids.include?(merchant.id)
      end
        return x.map{|m| m.name}
  end
end
