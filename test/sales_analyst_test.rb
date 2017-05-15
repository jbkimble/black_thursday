require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'pry'

class SalesAnalystClassTest < Minitest::Test

  def test_can_create_a_new_sales_analyst_object
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    assert_equal sa.class, SalesAnalyst
    #binding.pry
  end

  def test_method_average_items_per_merchant_returns_the_average
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    #sa.average_items_per_merchant

    assert_equal sa.average_items_per_merchant, 2.88 # => 2.88
  end

  def test_method_average_items_per_merchant_standard_deviation_returns_standard_deviation
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    assert_equal sa.average_items_per_merchant_standard_deviation, 3.26 # => 3.26
  end

  def test_method_merchants_with_high_item_count_return_merchants_that_are_more_than_one_standard_deviation_above_the_average_number_of_products_offered
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    sa.merchants_with_high_item_count
    assert_equal sa.merchants_with_high_item_count.count, 52
  end

  def test_method_average_item_price_for_merchant_returns_avg_price
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    assert_equal sa.average_item_price_for_merchant("12334105"), 1665.67 # => BigDecimal
  end

  def test_method_average_average_price_per_merchant_returns_avg_price_for_all_merchants
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    assert_equal sa.average_average_price_per_merchant, 35029.47
    #binding.pry # => BigDecimal

  end

  def test_method_golden_items_returns_items_2_sd_above_avg_price
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    sa = SalesAnalyst.new(se)
    assert_equal sa.golden_items.count, 3

  end

  def test_method_average_invoices_per_merchant_returns_avg_invoices
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal sa.average_invoices_per_merchant, 8.5
    binding.pry

  end
    #sa.average_invoices_per_merchant # => 8.5
  #  sa.average_invoices_per_merchant_standard_deviation # => 1.2


end
