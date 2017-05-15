require 'pry'
require 'csv'
require './lib/transaction.rb'

class TransactionRepository
  attr_reader :transactions

  def initialize(file_name, se_instance)
    @transactions = create_transctions(file_name, se_instance)
  end

  def create_transctions(file_name, se_instance)
    transactions = []
    CSV.foreach(file_name, :headers => true) do |row|
      transactions << Transaction.new(row, se_instance)
    end
    transactions
  end

  def all
    return transactions
  end

  def find_by_id(id)
    transactions.each do |transaction|
      return transaction if transaction.id == id
    end
      nil
  end

  def find_all_by_invoice_id(invoice_id)
    final = []
      transactions.each do |transaction|
        final << transaction if transaction.invoice_id == invoice_id
      end
        return final
  end

  def find_all_by_credit_card_number(credit_card_number)
    final = []
      transactions.each do |transaction|
        final << transaction if transaction.credit_card_number == credit_card_number
      end
        return final
  end

  def find_all_by_result(result)
    final = []
      transactions.each do |transaction|
        final << transaction if transaction.result == result
      end
        return final
  end


end
