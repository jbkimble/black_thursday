require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'pry'

class InvoiceClassTest < Minitest::Test

  def test_that_se_can_use_invoice_method
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    invoice = se.invoices
    #binding.pry#.find_by_id(6)
    assert_equal invoice.class, InvoiceRepository
    #binding.pry
  end

  def test_method_all_returns_all_invoices
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
    invoice = se.invoices
    assert_equal invoice.all.count, 4985
  end

  def test_method_find_by_id_returns_invoice_with_matching_id
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
      invoice = se.invoices
      assert_equal invoice.find_by_id("1").id, "1"
      #binding.pry
  end

  def test_method_find_all_by_customer_id_returns_all_customers_with_that_id
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
      invoice = se.invoices
      #invoice.find_all_by_customer_id("1")
      assert_equal invoice.find_all_by_customer_id("1").count, 8
  end

  def test_method_find_all_by_merchant_id_returns_all_invoices_with_matching_ids
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
      invoice = se.invoices
      assert_equal invoice.find_all_by_merchant_id("12335938").count, 16

  end

  def test_method_find_by_status_returns_all_invoices_with_corresponding_status
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"})
      invoice = se.invoices
      assert_equal invoice.find_all_by_status("pending").count, 1473
  end

  def test_method_invoices_can_be_called_on_merchant_and_returns_invoices_for_merchants
    se = SalesEngine.from_csv({
    :items => "./data/items.csv",
    :merchants => "./data/merchants.csv",
    :invoices => "./data/invoices.csv"
    })
    merchant = se.merchants.find_by_id("12334105")
    assert_equal merchant.invoices.count, 10

    invoice = se.invoices.find_by_id("20")
    assert_equal invoice.merchant, "RnRGuitarPicks"


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
end
