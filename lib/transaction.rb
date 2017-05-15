class Transaction
  attr_reader :id, :invoice_id, :credit_card_number,
              :credit_card_expiration_date, :result,
              :created_at, :updated_at, :se_instance

  def initialize(row, se_instance)
    @id = row["id"]
    @invoice_id = row["invoice_id"]
    @credit_card_number = row["credit_card_number"]
    @credit_card_expiration_date = row["credit_card_expiration_date"]
    @result = row["result"]
    @created_at = row["created_at"]
    @updated_at = row["updated_at"]
    @se_instance = se_instance
  end

  def invoice
    @se_instance.invoices.find_by_id(id)
  end
end
