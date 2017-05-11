require 'pry'
require 'csv'
require './lib/item.rb'

class ItemRepository
  attr_reader :items

  def initialize(file_name)
    @items = create_items(file_name)
  end

  def create_items(file_name)
    items = []
    CSV.foreach(file_name, :headers => true) do |row|
      items << Item.new(row)
    end
      return items
   end

   def all
     items
   end

   def find_by_name(name)
     items.each do |item|
       return item if item.name.upcase == name.upcase
     end
     nil
   end

   def find_by_id(id)
     items.each do |item|
       return item if item.id == id
     end
     nil
   end

   def find_all_by_description(description)
     final = []
     items.each do |item|
       final << item if item.description.upcase.include?(description.upcase)
     end
     final
   end

   def find_all_by_price(price)
     final = []
     items.each do |item|
       final << item if item.unit_price == price
     end
     final
   end

   def find_all_by_price_in_range(range)
     final = []
     items.each do |item|
       final << item if range.include?(item.unit_price)
     end
     final
   end

   def find_all_by_merchant_id(merchant_id)
     final = []
     items.each do |item|
       final << item if item.merchant_id == merchant_id
     end
     final 
   end
 end
