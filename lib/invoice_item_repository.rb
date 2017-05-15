require 'pry'
require 'csv'
require './lib/invoice_item.rb'

class InvoiceItemRepository
  attr_reader :invoice_items

  def initialize(file_name)
    @invoice_items = create_invoice_items(file_name)
  end

  def create_invoice_items(file_name)
    invoice_items = []
    CSV.foreach(file_name, :headers => true) do |row|
      invoice_items << InvoiceItem.new(row)
    end
      return invoice_items
   end

   def all
     return invoice_items
   end

   def find_all_by_customer_id(customer_id)
     customer_ids = []
       customers.each{|customer| customer_ids << customer if customer.customer_id == customer.id}
   end
   
   def find_by_id(id)
     invoice_items.each do |ii|
       return ii if ii.id == id
     end
       nil
   end

   def find_all_by_item_id(id)
     final = []
       invoice_items.each do |ii|
         final << ii if ii.item_id == id
       end
         return final
   end

   def find_all_by_invoice_id(id)
     final = []
       invoice_items.each do |ii|
         final << ii if ii.invoice_id == id
       end
         return final
   end


end
