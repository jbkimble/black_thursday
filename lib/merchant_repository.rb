require 'pry'
require 'csv'
require './lib/merchant.rb'

class MerchantRepository
  attr_reader :merchants

  def initialize(file_name)
    @merchants = create_merchants(file_name)
  end

  def create_merchants(file_name)
    merchants = []

    CSV.foreach(file_name, :headers => true) do |row|
      merchants << Merchant.new(row)
    end
    merchants
  end
end
