

class Merchant
  attr_reader :id, :name, :created_at

  def initialize(merchant_attributes, se_instance)
    @id = merchant_attributes["id"].to_i
    @name = merchant_attributes["name"]
    @created_at = merchant_attributes["created_at"]
    @se_instance = se_instance
  end

  def items
    @se_instance.items.find_all_by_merchant_id(id)
    #se instance calls method item which returns item repository object
    #call method find all by merchant id on item repository


    #method returns items that merchant sells

  end

  def invoices
    @se_instance.invoices.find_all_by_merchant_id(id)
  end

  def customers

    invoices_customer_ids = self.invoices.map{|i| i.customer_id}
    customers = @se_instance.customers.all.select{|c| invoices_customer_ids.include?(c.id)}

  end 
end
