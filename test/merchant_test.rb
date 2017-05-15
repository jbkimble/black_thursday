require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class MerchantClassTest < Minitest::Test

  def test_method_items_returns_all_items_for_merchants
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
    merchant = se.merchants.find_by_id("12334105")

    assert_equal merchant.items.count, 3
    #binding.pry


  end

  def test_method_merchant_ids_returns_an_array_of_ids
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
    merchant = se.merchants
    assert_equal merchant.merchant_ids.count, 475
    #binding.pry
    #assert_equal merchant.merchant_ids.class, Array

  end
end
