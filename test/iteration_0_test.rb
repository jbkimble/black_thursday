require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class SalesEngineTest < Minitest::Test

  def test_class_exists
    s = SalesEngine.new({:merchants => "./data/merchants.csv"})
    assert_equal SalesEngine, s.class
  end

  def test_sales_engine_class_can_take_data
    se = SalesEngine.from_csv({
      :merchants => "./data/merchants.csv"
      })

    assert_equal SalesEngine, se.class
  end

  def test_can_create_merchant_repository
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    mr = se.merchants
    assert_equal mr.class, MerchantRepository
  end

  def test_it_creates_merchant_objects
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    mr = se.merchants
    assert_equal mr.merchants.first.class, Merchant
    assert_equal mr.merchants.length, 475
    assert_equal mr.merchants.first.id, "12334105"
    assert_equal mr.merchants.first.name, "Shopin1901"
  end

end
