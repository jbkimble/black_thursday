require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class TransactionRepositoryTest < Minitest::Test

  def se
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
    })
  end

  def test_transaction_repository_is_a_method_for_sales_engine
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
    })
      assert_equal se.transactions.class, TransactionRepository
  end

  def test_transaction_object_has_attributes
    t = Transaction.new({
      "id" => 6,
      "invoice_id" => 8,
      "credit_card_number" => "4242424242424242",
      "credit_card_expiration_date" => "0220",
      "result" => "success",
      "created_at" => 1,
      "updated_at" => 2
    })

    assert_equal t.id, 6
    assert_equal t.invoice_id, 8
    assert_equal t.credit_card_number, "4242424242424242"
    assert_equal t.credit_card_expiration_date, "0220"
    assert_equal t.result, "success"
    assert_equal t.created_at, 1
    assert_equal t.updated_at, 2

  end

  def test_method_all_returns_all_transactions
    assert_equal se.transactions.all.count, 4985
  end

  def test_method_find_by_id_returns_transaction_with_id
    x = se.transactions.find_by_id("1")
    assert_equal x.invoice_id, "2179"
  end

  def test_method_find_all_by_invoice_id_returns_all_transactions_with_corresponding_invoice_id
    x = se.transactions.find_all_by_invoice_id("2179")
    assert_equal x.count, 2
    #binding.pry
  end

  def test_method_find_all_by_credit_card_number
    x = se.transactions.find_all_by_credit_card_number("4177816490204479")
    assert_equal x.count, 1
  end

  def test_method_find_all_by_result_returns_all_transactions_with_corresponding_result
    x = se.transactions.find_all_by_result("failed")
    assert_equal x.count, 827
  end
end
