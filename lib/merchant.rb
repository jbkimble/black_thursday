

class Merchant
  attr_reader :id, :name

  def initialize(merchant_attributes, se_instance)
    @id = merchant_attributes["id"]
    @name = merchant_attributes["name"]
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
    customers = @se_instance.invoices.find_all_by_merchant_id(id)
    #customer_ids = cumstomers.map{|customer| customer.customer_id}
    customer_ids = []
      customers.each do |customer|
        customer_ids << customer.id
      end
    @se_instance.customers.all.select{|c|customer_ids.include?(c.id)}
  end

end
