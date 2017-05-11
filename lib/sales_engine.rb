require './lib/merchant_repository.rb'
require './lib/item_repository.rb'
require 'pry'

class SalesEngine

  attr_reader :merchants, :items

  def initialize(csv_files)
  
    @merchants = create_merchants(csv_files[:merchants])
    @items = create_items(csv_files[:items])
  end

  def self.from_csv(csv_files)
    new(csv_files)
  end

  def create_merchants(file_name)
    MerchantRepository.new(file_name)
  end

  def create_items(file_name)

    ItemRepository.new(file_name)
  end
end
