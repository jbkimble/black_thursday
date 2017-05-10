require './lib/merchant_repository.rb'

class SalesEngine
  attr_reader :merchants

  def initialize(csv_files)
    @merchants = create_merchants(csv_files[:merchants])
  end

  def self.from_csv(csv_files)
    new(csv_files)
  end

  def create_merchants(file_name)
    MerchantRepository.new(file_name)
  end


end
