require 'pry'
require 'csv'
require_relative './customer.rb'

class CustomerRepository
  attr_reader :customers

    def initialize(file_name, se_instance)
      @customers = create_customers(file_name, se_instance)
    end

    def inspect
    "#<#{self.class} #{@merchants.size} rows>"
   end

    def create_customers(file_name, se_instance)
      customers = []
        CSV.foreach(file_name, :headers => true) do |row|
          customers << Customer.new(row, se_instance)
        end
          return customers
     end

     def all
       return customers
     end

     def find_by_id(id)
       customers.each{|customer| return customer if customer.id == id}
         return nil
     end

     def find_all_by_first_name(first_name)
       first_names = []
         customers.each{|customer| first_names << customer if customer.first_name.upcase.include?(first_name.upcase)}
           return first_names
     end

     def find_all_by_last_name(last_name)
       last_names = []
         customers.each{|customer| last_names << customer if customer.last_name.upcase.include?(last_name.upcase)}
           return last_names
     end
end
