require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require './lib/sales_analyst.rb'
require 'pry'

class ItemRepositoryTestClass < Minitest::Test

  def test_method_sort_by_id_returns_sorted_items_by_merchantid
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })
    x = se.items
    y = se.items.sort_by_id
  #  binding.pry
    #assert_equal se.items.first != se.items.sort_by_id.first
    # se.items.sort_by_id
     #binding.pry
  end

  def test_method_chunk_items_returns_items_chunked_by_merchant
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    x = se.items.sort_by_id
    x.chunk_items
  end
end
