require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class ItemsClassTest < Minitest::Test

  def test_method_merchant_returns_the_name_of_merchant_that_sells_item
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
    item = se.items.find_by_id("263395237")
    #binding.pry
    item.merchant
    #binding.pry
  end


end
