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

  def all
    merchants
  end

  def find_by_name(name)
    merchants.each do |merchant|
      return merchant if merchant.name.upcase == name.upcase
    end
    nil
  end

  def find_by_id(id)
    merchants.each do |merchant|
      return merchant if merchant.id == id
    end
    nil
  end

  def find_all_by_name(name_fragment)
    final = []
    merchants.each do |merchant|
      final << merchant if merchant.name.upcase.include?(name_fragment.upcase)
    end
    final
  end

end
