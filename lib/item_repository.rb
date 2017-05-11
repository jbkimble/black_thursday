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
    
    items
  end
end
