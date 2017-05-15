require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class RelationshipTest < Minitest::Test

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

  def test_invoice_is_able_to_use_various_methods
    invoice = se.invoices.find_by_id("3")
    assert_equal invoice.items.count, 2

    invoice1 = se.invoices.find_by_id("123")
    assert_equal invoice1.transactions.count, 4

    invoice2 = se.invoices.find_by_id("17")
    assert_equal invoice2.customer.first_name, "Sylvester"
  end

  def test_transation_can_use_invoice_method_to_return_the_invoice_from_the_transaction
    transaction = se.transactions.find_by_id("40")
    assert_equal transaction.invoice.customer_id, "9"
  end

  def test_merchant_can_use_customers_method_to_find_customers_who_have_bought_items
    merchant = se.merchants.find_by_id("12334105")
    assert_equal merchant.customers.count, 3

    #merchant.customers # => [customer, customer, customer]
  end

  def test_method_merchants_returns_the_merchants_the_customer_has_bought_from
    customer = se.customers.find_by_id("30")
    assert_equal customer.merchants.count, 5

    #customer.merchants # => [merchant, merchant]
  end

  def test_method_is_paid_in_full_returns_true_if_the_invoice_is_paid_in_full
    invoice = se.invoices.find_by_id("9")
    assert_equal invoice.paid_in_full?, false

    #invoice.is_paid_in_full? returns true if the invoice is paid in full
    #invoice.total returns the total $ amount of the invoice
  end

  def test_method_total_returns_the_total_dollar_amount_of_the_invoice
    invoice = se.invoices.find_by_id("2")
    assert_equal invoice.total, "$93880.0"

    #invoice.total

    #invoice.total returns the total $ amount of the invoice
  end
end
