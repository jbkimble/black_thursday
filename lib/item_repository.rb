require 'pry'
require 'csv'
require_relative './item.rb'


class ItemRepository
  attr_reader :items

  def initialize(file_name, se_instance)
    @items = create_items(file_name, se_instance)
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def create_items(file_name, se_instance)
    items = []
    CSV.foreach(file_name, :headers => true) do |row|
      items << Item.new(row, se_instance)
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

   def find_all_with_description(description)
     final = []
     items.each do |item|
       final << item if item.description.upcase.include?(description.upcase)
     end
     final
   end

   def find_all_by_price(price)
     final = []
     items.each do |item|
       final << item if item.unit_price_to_dollars == price.to_f
     end
     final
   end

   def find_all_by_price_in_range(range)
     final = []
     items.each do |item|
       final << item if range.include?(item.unit_price_to_dollars)
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

   def sort_by_id
     @sorted_items = items.sort_by{|item| item.merchant_id}
   end

   def chunk_items
     item_count = []
     chunked_items = @sorted_items.chunk{|item| item.merchant_id}.each{|arr| item_count << arr.count}
     return item_count
   end
 end
