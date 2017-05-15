require 'pry'
require 'csv'
require './lib/invoice.rb'

class InvoiceRepository
  attr_reader :invoices

  def initialize(file_name, se_instance)
    @invoices = create_invoices(file_name, se_instance)
  end

  def create_invoices(file_name, se_instance)
    invoices = []
    CSV.foreach(file_name, :headers => true) do |row|
      invoices << Invoice.new(row, se_instance)
    end
      return invoices
  end

  def all
    return invoices
  end

  def find_by_id(id)
    invoices.each do |invoice|
      return invoice if invoice.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    final = []
    invoices.each do |invoice|
      final << invoice if invoice.customer_id == customer_id
    end
      return final
  end

  def find_all_by_merchant_id(merchant_id)
    final = []
    invoices.each do |invoice|
      final << invoice if invoice.merchant_id == merchant_id
    end
      return final
  end

  def find_all_by_status(status)
    final = []
    invoices.each{|invoice| final << invoice if invoice.status == status}
      return final
  end
end
