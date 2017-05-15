require './lib/invoice_repository.rb'

class Invoice
  attr_reader :id, :customer_id, :merchant_id,
              :status, :created_at, :updated_at

  def initialize(row, se_instance)
    @id = row["id"]
    @customer_id = row["customer_id"]
    @merchant_id = row["merchant_id"]
    @status = row["status"]
    @created_at = row["created_at"]
    @updated_at = row["updated_at"]
    @se_instance = se_instance
  end

  def merchant
    @se_instance.merchants.find_by_id(merchant_id).name
  end

  def items
    @se_instance.items.find_all_by_merchant_id(merchant_id)
  end

  def transactions
    all_invoices = @se_instance.invoices.find_all_by_customer_id(customer_id)
    all_transactions = []
      all_invoices.each do |invoice|
        all_transactions << invoice.id
      end
    final = []
      @se_instance.transactions.all.each do |transaction|
        final << transaction if all_transactions.include?(transaction.id)
      end
        return final
  end

  def customer
    @se_instance.customers.find_by_id(customer_id)
  end

  def paid_in_full?
    transactions = []
    @se_instance.transactions.all.each do |transaction|
      transactions << transaction.result if transaction.id == id
    end
      return true if transactions.join == "success"
        false
  end

  def total

  end
end
