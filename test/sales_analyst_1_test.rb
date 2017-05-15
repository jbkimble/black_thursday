require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'pry'

class SalesAnalystClassTest < Minitest::Test

  def test_method_average_invoices_per_merchant_returns_avg_invoices
  se = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv"})
  sa = SalesAnalyst.new(se)
  assert_equal sa.average_invoices_per_merchant, 8.5


  end

  def test_method_average_invoices_per_merchant_standard_deviation_returns_sd
  se = SalesEngine.from_csv({
    :items     => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv"})
  sa = SalesAnalyst.new(se)
  assert_equal sa.average_invoices_per_merchant_standard_deviation, 1.2
  end

  def test_method_top_merchants_by_invoice_count_returns_merchants_2sd_above_mean
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal sa.top_merchants_by_invoice_count.count, 228
    #binding.pry # => [merchant, merchant, merchant]
  end

  def test_method_bottom_merchants_by_invoice_count_return_merchants_2sd_below_mean
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal sa.bottom_merchants_by_invoice_count.count, 48
    #binding.pry
    #sa.bottom_merchants_by_invoice_count.count, 100
  end

  def test_method_top_days_by_invoice_count_returns_days_where_avg_is_more_then_2sd_above
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal sa.top_days_by_invoice_count, "Wednesday"

    #sa.top_days_by_invoice_count, 1

  end

  def test_method_invoice_status_returns_the_percentage_of_like_statuses
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    sa = SalesAnalyst.new(se)
    assert_equal sa.invoice_status(:pending), 29.55 # => 5.25
    assert_equal sa.invoice_status(:shipped), 56.95 # => 93.75
    assert_equal sa.invoice_status(:returned), 13.5 # => 1.00
    
  end

end
