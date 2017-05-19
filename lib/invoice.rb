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

  def is_paid_in_full?
    transactions = @se_instance.transactions.all.select{|t| t.invoice_id == id}
    success_or_failure = transactions.map{|t| t.result}
      if success_or_failure.include?("failed") || transactions.empty?
        return false
      end
        true
  end

  def total
    if self.is_paid_in_full?
      invoice_items = @se_instance.invoice_items.all.select{|ii| ii.invoice_id == id}
      prices = invoice_items.map{|ii| [ii.unit_price, ii.quantity]}
        return total = BigDecimal.new(prices.map{|arr| arr.reduce(:*)}.reduce(:+))
    end
  end

  def invoice_items
    @se_instance.invoice_items.all.select{|ii| ii.invoice_id == id}
  end
end
