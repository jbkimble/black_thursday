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
end
