require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'pry'

class MerchantAnalyticsTest < Minitest::Test

  def se
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
    })
  end

  def test_method_total_revenue_by_date_returns_the_amount_in_dollars
    sa = SalesAnalyst.new(se)
    assert_equal sa.total_revenue_by_date("2012-11-23"), "The total revenue for 2012-11-23 is $508249.0"
    assert_equal sa.total_revenue_by_date("1000"), "There were no sales on 1000"
  end

  def test_method_top_revenue_earners_returns_the_top_earning_merchants
    sa = SalesAnalyst.new(se)
    assert_equal sa.top_revenue_earners(5).count, 5
    assert_equal sa.top_revenue_earners(5).first, "Keckenbauer"#=> [merchant, merchant, merchant, merchant, merchant]
    assert_equal sa.top_revenue_earners.count, 20
  end

  def test_method_merchants_with_pending_invoices_returns_merchants_with_invoices_pending
    sa = SalesAnalyst.new(se)
    assert_equal sa.merchants_with_pending_invoices.count, 385 #=> [merchant, merchant, merchant]
    #Note: an invoice is considered pending if none of its transactions are successful.
  end

  def test_method_merchants_with_only_one_item_returns_merchants_with_one_item
    sa = SalesAnalyst.new(se)
    assert_equal sa.merchants_with_only_one_item.count, 243 #=> [merchant, merchant, merchant]
  end

  def test_method_merchants_with_only_one_item_registered_in_month_returns_merchants_that_only_registered_one_item_in_given_month
    sa = SalesAnalyst.new(se)
    assert_equal sa.merchants_with_only_one_item_registered_in_month("January").count, 19 #=> [merchant, merchant, merchant]
  end

  def test_method_revenue_per_merchant_returns_the_revenue_in_dollars_for_corresponding_merchant_id
    sa = SalesAnalyst.new(se)
    assert_equal sa.revenue_by_merchant("12334112"), "$519026" #=> $
  end

  def test_method_most_sold_item_for_merchant_returns_item_that_sold_the_most
    sa = SalesAnalyst.new(se)
    assert_equal sa.most_sold_item_for_merchant("12334105"), ["Vogue Paris Original Givenchy 2307"] #=> [item] (in terms of quantity sold) or, if there is a tie, [item, item, item]
  end

  def test_method_best_item_for_merchant_returns_the_item_that_has_produced_the_most_revenue
    sa = SalesAnalyst.new(se)
    assert_equal sa.best_item_for_merchant("12334113"), ["Custom Hand Made Miniature Bicycle"] #=> item (in terms of revenue generated)
  end


end
