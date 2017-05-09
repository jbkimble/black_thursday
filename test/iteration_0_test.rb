require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'

class SalesEngineTest < Minitest::Test

  def test_class_exists
    s = SalesEngine.new
    assert_equal SalesEngine, s.class
  end

  def test_sales_engine_class_can_take_data
    se = SalesEngine.from_csv({
      :merchants => "./data/merchants.csv"
      })

    assert_equal MerchantRepository, se.merchants.class
  end

end
