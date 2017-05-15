require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class InvoiceItemRepositoryTest < Minitest::Test

  def test_invoice_item_repository_is_a_method_of_sales_engine
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",

    })
    assert_equal se.invoice_items.class, InvoiceItemRepository
    #invoice = ir.find_by_id(6)

  end

  def test_invoice_object_returns_attributes


    ii = InvoiceItem.new({
      "id" => 6,
      "item_id" => 7,
      "invoice_id" => 8,
      "quantity" => 1,
      "unit_price" => 11.0,
      "created_at" => 1,
      "updated_at" => 2
    })

    assert_equal ii.id, 6
    assert_equal ii.item_id, 7
    assert_equal ii.invoice_id, 8
    assert_equal ii.quantity, 1
    assert_equal ii.unit_price, 11.0
    assert_equal ii.created_at, 1
    assert_equal ii.updated_at, 2

  end

  def test_method_all_returns_all_invoice_item_instances
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
    })

    assert_equal se.invoice_items.all.count, 21830
  end

  def test_method_find_by_id_returns_invoice_item_with_matching_id
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
    })
    ii = se.invoice_items
    x = ii.find_by_id("1")
    assert_equal x.item_id, "263519844"
  end

  def test_method_find_all_by_item_id_returns_all_items_with_corresponding_id
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
    })
    ii = se.invoice_items
    x = ii.find_all_by_item_id("263454779")
    assert_equal x.count, 18
    #binding.pry
  end

  def test_method_find_all_by_invoice_id_returns_all_invoice_items_with_corresponding_invoice_ids
    se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
    })
    ii = se.invoice_items
    x = ii.find_all_by_invoice_id("2")
    assert_equal x.count, 4
  end
end
