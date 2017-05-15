require './lib/sales_engine.rb'
require 'date'

class SalesAnalyst
  attr_reader :items_count, :average

  def initialize(se_instance)
    @se_instance = se_instance

    merchants = @se_instance.merchants
    ids = merchants.merchant_ids

    merchants1 = []
      ids.each do |id|
        merchants1 << @se_instance.merchants.find_by_id(id)
      end
    @items_count = []
      merchants1.each do |merchant|
        items_count << merchant.items.count
      end
  end

  def average_items_per_merchant
    return average = ((items_count.reduce(:+).to_f)/(items_count.count)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    new_nums = []
    @items_count.each do |num|
      new_nums << (num - self.average_items_per_merchant)**2
    end
      sd = new_nums.reduce(:+) / (@se_instance.items.all.count - 1)
        return sd = Math.sqrt(sd).round(2)
  end

  def merchants_with_high_item_count
    one_sd_above = average_items_per_merchant + average_items_per_merchant_standard_deviation
    m = @items_count.each_with_index.select{|num, idx| num > one_sd_above}.map{|num, idx| idx}
    ids = @se_instance.merchants.merchant_ids
    merchant_ids = []
      ids.each_with_index do |id, idx|
        if m.include?(idx)
          merchant_ids << id
        end
      end

    merchants = []
      merchant_ids.each do |id|
        merchant_object = @se_instance.merchants.find_by_id(id)
        merchants << merchant_object.name
      end
        return merchants
  end

  def average_item_price_for_merchant(id)
    items = @se_instance.merchants.find_by_id(id).items
    prices = []
      items.each do |item|
        prices << item.unit_price_to_dollars
      end
    avg_price = prices.reduce(:+) / prices.count
      return avg_price.round(2)
  end

  def average_average_price_per_merchant
      ids = @se_instance.merchants.merchant_ids
      prices = []
        ids.each do |id|
          prices << average_item_price_for_merchant(id)
        end
          return (prices.reduce(:+) / prices.count).round(2)
  end

  def golden_items
    ids = @se_instance.merchants.merchant_ids
    prices = []
      ids.each do |id|
        prices << average_item_price_for_merchant(id)
      end
    avg = self.average_average_price_per_merchant
    new_prices = []
      prices.each do |price|
        new_prices << (price - avg) ** 2
      end
    sd = new_prices.reduce(:+) / (new_prices.count - 1)
    sd = Math.sqrt(sd).round(2)
    two_sd_above = avg + (2 * sd)
    items = @se_instance.items.all
    g = []
      items.each do |item|
        if item.unit_price_to_dollars > two_sd_above
          g << item
        end
      end
        return g
    end

    def average_invoices_per_merchant
      invoices = []
      merchants = @se_instance.merchants.all
        merchants.each do |merchant|
          id = merchant.id
          invoices << @se_instance.invoices.find_all_by_merchant_id(id).count
        end
          return avg = (invoices.reduce(:+).to_f / invoices.count - 2).round(1)
    end

    def average_invoices_per_merchant_standard_deviation
      avg = self.average_invoices_per_merchant
      invoices = []
      merchants = @se_instance.merchants.all
        merchants.each do |merchant|
          id = merchant.id
          invoices << @se_instance.invoices.find_all_by_merchant_id(id).count
        end
      new_nums = []
        invoices.each do |num|
          new_nums << (num - avg) ** 2
        end
      sd = new_nums.reduce(:+).to_f / (@se_instance.invoices.all.count - 1)
      sd = Math.sqrt(sd).round(1)
    end

    def top_merchants_by_invoice_count
      two_sd_above = self.average_invoices_per_merchant + (2 * self.average_invoices_per_merchant_standard_deviation)
      invoices = []
      merchants = @se_instance.merchants.all
        merchants.each do |merchant|
          id = merchant.id
          invoices << @se_instance.invoices.find_all_by_merchant_id(id).count
        end
      top_merchants = []
        invoices.each_with_index do |num, idx|
          top_merchants << idx if num > two_sd_above
        end

      final = []
        merchants.each_with_index do |merchant, idx|
          final << merchant.name if top_merchants.include?(idx)
        end
          return final
    end

    def bottom_merchants_by_invoice_count
      two_sd_below = self.average_invoices_per_merchant - (2 * average_invoices_per_merchant_standard_deviation)
      invoices = []
      merchants = @se_instance.merchants.all
        merchants.each do |merchant|
          id = merchant.id
          invoices << @se_instance.invoices.find_all_by_merchant_id(id).count
        end
      bottom_merchants = []
        invoices.each_with_index do |num, idx|
          bottom_merchants << idx if num < two_sd_below
        end

      final = []
        merchants.each_with_index do |merchant, idx|
          final << merchant.name if bottom_merchants.include?(idx)
        end
          return final
    end

    def top_days_by_invoice_count
      #this method doesnt return sat and sun? returns wednesday
      days_of_the_week = {
        "Monday" => 0,
        "Tuesday" => 0,
        "Wednesday" => 0,
        "Thursday" => 0,
        "Friday" => 0,
        "Saturday" => 0,
        "Sunday" => 0,
        }
      invoices = @se_instance.invoices.all
        invoices.each do |invoice|
          days_of_the_week[weekday(invoice.created_at)] += 1
        end
        avg_invoices_per_day = []
          days_of_the_week.each do |key, value|
            avg_invoices_per_day << value
          end
        avg = avg_invoices_per_day.reduce(:+) / avg_invoices_per_day.count

        new_nums = []
          avg_invoices_per_day.each do |num|
            new_nums << (num - avg) ** 2
          end
        sd = new_nums.reduce(:+).to_f / (new_nums.count - 1)
        sd = Math.sqrt(sd).round(2)

        sd_above = avg + sd
        final = []
          days_of_the_week.each do |key, value|
            final << key if value > sd_above
          end
            return final.join
    end

    def weekday(date_string)
      Date.parse(date_string).strftime("%A")
    end

    def invoice_status(status)
      current_status = status.to_s
      invoices = @se_instance.invoices.all
      statuses = []
        invoices.each do |invoice|
          statuses << invoice.status
        end
      correct_status = statuses.select{|status| status == current_status}.count
        return percentage = ((correct_status.to_f / statuses.count) * 100).round(2)
    end
end
