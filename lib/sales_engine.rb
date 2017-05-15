require './lib/merchant_repository.rb'
require './lib/item_repository.rb'
require './lib/invoice_repository.rb'
require './lib/invoice_item_repository.rb'
require './lib/transaction_repository.rb'
require "./lib/customer_repository.rb"
require 'pry'

class SalesEngine

  attr_reader :merchants, :items, :invoices, :invoice_items,
              :transactions, :customers

  def initialize(csv_files)
    @merchants = create_merchants(csv_files[:merchants])
    @items = create_items(csv_files[:items])
    @invoices = create_invoices(csv_files[:invoices])
    @invoice_items = create_invoice_items(csv_files[:invoice_items])
    @transactions = create_transctions(csv_files[:transactions])
    @customers = create_customers(csv_files[:customers])
  end

  def self.from_csv(csv_files)
    new(csv_files)
  end

  def create_merchants(file_name)
    MerchantRepository.new(file_name, self)
  end

  def create_items(file_name)
    ItemRepository.new(file_name)
  end

  def create_invoices(file_name)
    InvoiceRepository.new(file_name, self)
  end

  def create_invoice_items(file_name)
    InvoiceItemRepository.new(file_name)
  end

  def create_transctions(file_name)
    TransactionRepository.new(file_name, self)
  end

  def create_customers(file_name)
    CustomerRepository.new(file_name, self)
  end
end
