require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class SalesEngineTest < Minitest::Test

  def test_class_exists

    s = sales_engine_instance

    assert_equal SalesEngine, s.class
  end

  def test_sales_engine_class_can_take_data
    se = sales_engine_instance

    assert_equal SalesEngine, se.class
  end

  def test_can_create_merchant_repository
    se = sales_engine_instance

    mr = se.merchants
    assert_equal mr.class, MerchantRepository
  end

  def test_it_creates_merchant_objects
    se = sales_engine_instance

    mr = se.merchants
    assert_equal mr.merchants.first.class, Merchant
    assert_equal mr.merchants.length, 475
    assert_equal mr.merchants.first.id, "12334105"
    assert_equal mr.merchants.first.name, "Shopin1901"
  end

  def test_merchant_repository_can_return_all_merchants
    se = sales_engine_instance

    mr = se.merchants
    all_merchants = mr.all

    assert_equal all_merchants.class, Array
    assert_equal all_merchants.length, 475
  end

  def test_merchant_repository_can_find_by_name
    se = sales_engine_instance

    mr = se.merchants
    a_merchant = mr.find_by_name("HeadyMamaCreations")

    assert_equal a_merchant.name, "HeadyMamaCreations"
    assert_equal a_merchant.id, "12337321"
  end

  def test_merchant_repository_returns_nil_if_name_doesnt_exist
    se = sales_engine_instance

    mr = se.merchants
    a_merchant = mr.find_by_name("HeadyMamas")

    assert_nil a_merchant
  end

  def test_merchant_repository_can_find_by_id
    se = sales_engine_instance

    mr = se.merchants
    a_merchant = mr.find_by_id("12337321")

    assert_equal a_merchant.name, "HeadyMamaCreations"
    assert_equal a_merchant.id, "12337321"
  end

  def test_merchant_repository_returns_nil_if_id_doesnt_exist
    se = sales_engine_instance

    mr = se.merchants
    a_merchant = mr.find_by_id("HeadyMamas")

    assert_nil a_merchant
  end

  def test_merchant_repository_can_find_all_by_name
    se = sales_engine_instance

    mr = se.merchants
    final = mr.find_all_by_name("creations")

    assert_equal 8, final.count
  end

  def test_merchant_repository_returns_nil_if_id_doesnt_exist
    se = sales_engine_instance

    mr = se.merchants
    a_merchant = mr.find_all_by_name("99999")

    assert_equal a_merchant, []
  end

  def test_getting_items_from_csv
    ir = sales_engine_instance.items
    assert_equal ir.items.count, 1367
  end

  def test_item_object_can_access_correct_attributes
    i = Item.new({
      "id"         => 800,
      "name"        => "Pencil",
      "description" => "You can use it to write things",
      "unit_price"  => 0,
      "created_at"  => 11,
      "updated_at"  => 12,
      "merchant_id" => 1001
      })

      assert_equal i.id, 800
      assert_equal i.name, "Pencil"
      assert_equal i.description, "You can use it to write things"
      assert_equal i.unit_price, 0
      assert_equal i.created_at, 11
      assert_equal i.updated_at, 12
      assert_equal i.merchant_id, 1001
  end

  def test_uni_price_to_dollars_returns_float
    i = Item.new({
      "id"         => 800,
      "name"        => "Pencil",
      "description" => "You can use it to write things",
      "unit_price"  => 10,
      "created_at"  => 11,
      "updated_at"  => 12,
      "merchant_id" => 1001
      })

    assert_equal i.unit_price_to_dollars.class, Float


  end

  def test_item_repository_all_returns_all_items
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv"
      })

    ir   = se.items
    assert_equal ir.all.count, 1367
    x = ir.find_by_name("Glitter scrabble frames")
    assert_equal x.name, "Glitter scrabble frames"
    assert_equal x.id, "263395617"

    y = ir.find_all_by_description("Any colour glitter")
    assert_equal y.size, 4
    z = ir.find_all_by_price("1300")
    assert_equal y.size, 4

    a = ir.find_all_by_price_in_range(("1000".."1300"))
    assert_equal a.size, 126

    b = ir.find_all_by_merchant_id("12334185")
    binding.pry
    assert_equal b.size, 6
  end



  def sales_engine_instance
    SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
  end
end
