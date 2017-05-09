require './lib/merchant_repository.rb'

class SalesEngine

  def self.from_csv(csv_hash)
    csv_hash.each do |key, value|
      if key == :merchants
        #extract this to a different class and intantiate object
        # of said class here to start upload process.
        import_merchants(value)
      end
    end
    # Creates an object based on the key in the hash
    # object contains all csv rows as individual objects



  end

  def import_merchants(value)
    repo = MerchantRepository.new
  end

end
