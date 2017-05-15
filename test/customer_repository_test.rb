require 'minitest/autorun'
require 'minitest/pride'
require './lib/sales_engine.rb'
require 'pry'

class CustomerRepositoryTest < Minitest::Test

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

    def test_customers_is_method_of_se
      assert_equal se.customers.class, CustomerRepository
    end

    def test_customer_has_attributes
      c = Customer.new({
        "id" => 6,
        "first_name" => "Joan",
        "last_name" => "Clarke",
        "created_at" => 1,
        "updated_at" => 2
      })

      assert_equal c.id, 6
      assert_equal c.first_name, "Joan"
      assert_equal c.last_name, "Clarke"
      assert_equal c.created_at, 1
      assert_equal c.updated_at, 2

    end

    def test_method_all_returns_all_customers
      #se.customers.all
      #binding.pry
      assert_equal se.customers.all.count, 1000
    end

    def test_method_find_by_id_returns_customer_with_corresponding_id
      x = se.customers.find_by_id("3")
      assert_equal x.first_name, "Mariah"
    end

    def test_method_find_all_by_first_name_returns_all_customers_that_contain_fragment_in_first_name
      x = se.customers.find_all_by_first_name("Parker")
      assert_equal x.count, 2
    end

    def test_method_find_all_by_last_name_returns_all_customers_that_contain_fragment_in_last_name
      x = se.customers.find_all_by_last_name("Park")
      assert_equal x.count, 3 
    end

end
