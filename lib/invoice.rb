require_relative './invoice_repository.rb'
require 'time'
class Invoice
  attr_reader :id, :customer_id, :merchant_id,
              :status, :created_at, :updated_at

  def initialize(row, se_instance)
    @id = row["id"].to_i
    @customer_id = row["customer_id"].to_i
    @merchant_id = row["merchant_id"].to_i
    @status = row["status"].to_sym
    @created_at = Time.parse(row["created_at"])#need to change offset by 2
    @updated_at = Time.parse(row["updated_at"])#^
    @se_instance = se_instance
  end

  def merchant
    @se_instance.merchants.find_by_id(merchant_id)
  end

  def items
    invoice_item_item_ids = @se_instance.invoice_items.find_all_by_invoice_id(id).map{|ii|ii.item_id}
    items = @se_instance.items.all.select{|i|invoice_item_item_ids.include?(i.id)}
  end

  def transactions
    transactions = @se_instance.transactions.all.select{|t| t.invoice_id == id}
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

    invoice_items = []
      @se_instance.invoice_items.all.each do |invoice_item|
        invoice_items << invoice_item if invoice_item.invoice_id == id
      end
    prices = []
      invoice_items.each do |invoice_item|
        prices << invoice_item.unit_price
      end
    prices = prices.map{|str| str.to_i}
      return "$#{prices.reduce(:+).to_f.round(2)}"

  end
end
