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

  def sales_engine_instance
    SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
  end
end
