require_relative './sales_engine.rb'
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
    self.items_count.each do |num|
      new_nums << (num - self.average_items_per_merchant)**2
    end
      sd = new_nums.reduce(:+) / (new_nums.count)
        return sd = Math.sqrt(sd).round(2)
  end

  def merchants_with_high_item_count
    one_sd_above = average_items_per_merchant + average_items_per_merchant_standard_deviation
    m = self.items_count.each_with_index.select{|num, idx| num > one_sd_above}.map{|num, idx| idx}
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
        merchants << merchant_object
      end
        return merchants
  end

  def average_item_price_for_merchant(id)
    items = @se_instance.merchants.find_by_id(id).items
    prices = []
      items.each do |item|
        prices << item.unit_price
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
    prices = []
      @se_instance.items.all.each do |item|
        prices << item.unit_price
      end
    avg = self.average_average_price_per_merchant
    new_prices = []
      prices.each do |price|
        new_prices << (price - avg) ** 2
      end
    s = new_prices.reduce(:+) / (new_prices.count)
    sd = Math.sqrt(s).round(2)
    two_sd_above = avg + (2 * sd)
    items = @se_instance.items.all
    g = []
      items.each do |item|
        g << item if item.unit_price_to_dollars > two_sd_above
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
          return avg = (invoices.reduce(:+).to_f / invoices.count).round(2)
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
      sd = new_nums.reduce(:+).to_f / (new_nums.count)
      sd = Math.sqrt(sd).round(2)
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
          final << merchant if top_merchants.include?(idx)
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
          final << merchant if bottom_merchants.include?(idx)
        end
          return final
    end

    def top_days_by_invoice_count
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
          days_of_the_week[weekday(invoice.created_at.to_s[0..9])] += 1
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
            return final
    end

    def weekday(date_string)
      Date.parse(date_string).strftime("%A")
    end

    def invoice_status(status)
      invoices = @se_instance.invoices.all
      statuses = []
        invoices.each do |invoice|
          statuses << invoice.status
        end
      correct_status = statuses.select{|s| s == status}.count
        return percentage = ((correct_status.to_f / statuses.count) * 100).round(2)
    end

    def total_revenue_by_date(date)
      invoice_ids = @se_instance.invoices.all.select{|i| i.created_at == date}.map{|i| i.id}
      invoice_items = @se_instance.invoice_items.all.select{|ii| invoice_ids.include?(ii.invoice_id)}
        return prices = BigDecimal.new(invoice_items.map{|ii| [ii.unit_price, ii.quantity]}.map{|arr| arr.reduce(:*)}.reduce(:+))
    end

    def merchant_revenue
      successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success"}.map{|t| t.invoice_id}
      successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
      invoices = {}
        successful_invoices.each do |i|
          invoices[i.id] = []
        end
     invoices_ids = invoices.map{|k,v| k}
        @se_instance.invoice_items.all.each do |ii|
          if invoices_ids.include?(ii.invoice_id)
          invoices[ii.invoice_id] << ii
          end
        end

      invoice_with_amount = invoices.map{|k,v| [k, v.map{|x| (x.quantity * x.unit_price)}]}.map{|arr| arr[1].reduce(:+)}#tried multiplying unit price by quantity

      merchant_ids = []
        successful_invoices.each do |i|
          merchant_ids << i.merchant_id
        end

      x = merchant_ids.zip(invoice_with_amount).sort_by{|arr| arr[0]}.chunk{|arr| arr[0]}.to_a.flatten(2)

      merchant_ids_with_amounts = {}
        @se_instance.merchants.all.each do |m|
          merchant_ids_with_amounts[m.id] = 0
        end

      x.delete_if{|x| x.is_a?(Integer) || x.include?(nil)}
       x.each do |arr|
         merchant_ids_with_amounts[arr[0]] += arr[1]
       end
         return final = merchant_ids_with_amounts.sort_by{|k,v| v}.reverse

       merchant_revenue = {}
         @se_instance.merchants.all.each do |m|
           merchant_revenue[m.id] = 0
         end
         @se_instance.items.all.each do |item|
           relevant_invoice_items_info.each do |arr|
             if item.id == arr[0]
               merchant_revenue[item.merchant_id] += (arr[1] * arr[2])
             end
           end
         end

       @se_instance.invoices.all.each do |i|
         if invoices_count[i.id] > 0
           merchant_revenue[i.merchant_id] *= invoices_count[i.id]
         end
       end
    end

    def top_revenue_earners(x = 20)
      merchant_revenue = self.merchant_revenue
      tm_ids = merchant_revenue[0...x].map{|arr| arr[0]}
      top_merchants = {}
        tm_ids.each do |id|
          top_merchants[id] = []
        end
        @se_instance.merchants.all.each do |merchant|
          top_merchants[merchant.id] << merchant if tm_ids.include?(merchant.id)
        end
          return top_merchants.flatten.flatten.delete_if{|x| x.is_a?(Integer)}
     end

     def merchants_with_pending_invoices
       invoices = {}
         @se_instance.invoices.all.each do |i|
           invoices[i.id] = []
         end
         @se_instance.transactions.all.each do |t|
           invoices[t.invoice_id] << t.result
         end

        invoices_with_all_failures = invoices.reject{|k,v| v.include?("success")}
        invoice_ids = invoices_with_all_failures.map{|k,v| k}
        merchants = []
          @se_instance.invoices.all.each do |i|
            merchants << i.merchant_id if invoice_ids.include?(i.id)
          end
            return final = @se_instance.merchants.all.select{|m| merchants.include?(m.id)}
     end

     def merchants_with_only_one_item
       merchants = {}
         @se_instance.merchants.all.each do |merchant|
           merchants[merchant.id] = 0
         end
         @se_instance.items.all.each do |item|
           merchants[item.merchant_id] += 1
         end
       merchants_with_one_item = merchants.select{|k,v| v == 1}.map{|k,v| k}
       names = []
         @se_instance.merchants.all.each do |merchant|
           names << merchant if merchants_with_one_item.include?(merchant.id)
         end
           return names
      end

      def merchants_with_only_one_item_registered_in_month(month_string)
        merchants_per_month = {
          "01" => [],
          "02" => [],
          "03" => [],
          "04" => [],
          "05" => [],
          "06" => [],
          "07" => [],
          "08" => [],
          "09" => [],
          "10" => [],
          "11" => [],
          "12" => []
        }
        months = {
          "January" => "01",
          "February" => "02",
          "March" => "03",
          "April" => "04",
          "May" => "05",
          "June" => "06",
          "July" => "07",
          "August" => "08",
          "September" => "09",
          "October" => "10",
          "November" => "11",
          "December" => "12"
         }

       merchants_with_one_item = self.merchants_with_only_one_item
       merchants_with_one_item = merchants_with_one_item.map{|m| m.name}
       merchants_with_one = @se_instance.merchants.all.select{|m| merchants_with_one_item.include?(m.name)}
       merchants_with_one.each do |m|
         month = m.created_at[/\-(.*)-/,1]
         merchants_per_month[month] << m
      end

      current_month = months[month_string]
        return merchants_per_month[current_month]
    end

    def revenue_by_merchant(merchant_id)
      merchant_revenue = self.merchant_revenue
        merchant_revenue.each do |arr|
          return arr[1] if arr[0] == merchant_id
        end
    end

    def merchants_ranked_by_revenue
      merchant_revenue = self.merchant_revenue
      merchant_ids = merchant_revenue.map{|arr| arr[0]}
      merchants = {}
        merchant_revenue.each do |arr|
          merchants[arr[0]] = []
        end
        @se_instance.merchants.all.each do |merchant|
          merchants[merchant.id] << merchant if merchant_ids.include?(merchant.id)
        end
          return merchants.flatten.flatten.delete_if{|x| x.is_a?(Integer)}
    end

    def most_sold_item_for_merchant(merchant_id)
      successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success"}.map{|t| t.invoice_id}
      successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
      invoice_ids = successful_invoices.map{|i| i.id}
      invoices = {}
        invoice_ids.each do |i|
          invoices[i] = []
        end
        @se_instance.invoice_items.all.each do |ii|
          if invoice_ids.include?(ii.invoice_id)
            invoices[ii.invoice_id] << [ii.item_id, ii.quantity]
          end
       end
       invoice1 = invoices.map{|k,v| k}
       merchants = {}
        @se_instance.invoices.all.each do |i|
          if invoice1.include?(i.id)
            merchants[i.merchant_id] = []
          end
        end
        @se_instance.invoices.all.each do |i|
          invoices.each do |k,v|
            if i.id == k
              merchants[i.merchant_id] << v
            end
          end
        end

      max = merchants[merchant_id].flatten(1).sort_by{|arr| arr[1]}.reverse[0][1]
      final = merchants[merchant_id].flatten(1).select{|arr| arr[1] == max}.map{|arr| arr[0]}
      items = []
        @se_instance.items.all.each do |item|
          items << item if final.include?(item.id)
        end
          return items
    end

    def best_item_for_merchant(merchant_id)
      successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success"}.map{|t| t.invoice_id}
      successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
      invoice_ids = successful_invoices.map{|i| i.id}
      invoices = {}
        invoice_ids.each do |i|
          invoices[i] = []
        end
        @se_instance.invoice_items.all.each do |ii|
          if invoice_ids.include?(ii.invoice_id)
            invoices[ii.invoice_id] << [ii.item_id, (ii.quantity * ii.unit_price)]
          end
       end
       invoice1 = invoices.map{|k,v| k}
       merchants = {}
       @se_instance.invoices.all.each do |i|
         if invoice1.include?(i.id)
           merchants[i.merchant_id] = []
         end
       end
       @se_instance.invoices.all.each do |i|
         invoices.each do |k,v|
           if i.id == k
             merchants[i.merchant_id] << v
           end
         end
       end

     max = merchants[merchant_id].flatten(1).sort_by{|arr| arr[1]}.reverse[0][1]
     final = merchants[merchant_id].flatten(1).select{|arr| arr[1] == max}.map{|arr| arr[0]}
       @se_instance.items.all.each do |item|
         return item if final.include?(item.id)
       end
    end

    def top_buyers(t = 20)
      successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success" }.map{|t| t.invoice_id}
      successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
      customers_with_invoices = {}
        @se_instance.customers.all.each do |c|
          customers_with_invoices[c.id] = []
        end
        successful_invoices.each do |i|
          customers_with_invoices[i.customer_id] << i.id
        end

      invoices_with_invoice_items = {}
        successful_invoices.each do |i|
          invoices_with_invoice_items[i.id] = []
        end
      successful_invoice_ids = successful_invoices.map{|i| i.id}
      successful_invoice_items = @se_instance.invoice_items.all.select{|ii| successful_invoice_ids.include?(ii.invoice_id)}
        successful_invoice_items.each do |ii|
          invoices_with_invoice_items[ii.invoice_id] << [ii.quantity * ii.unit_price]
        end
      final = []
      x = invoices_with_invoice_items.map{|k, v| [k, v.flatten.reduce(:+)]}
      customers_with_invoices.each do |k, v|
        x.each do |arr|
          if v.include?(arr[0])
            final << [k, arr[1]]
          end
        end
      end
      y = final.chunk{|arr|arr[0]}.map{|arr| [arr[0], arr[1].map{|arr| arr[1]}]}.map{|arr| [arr[0], arr[1].reduce(:+)]}.sort_by{|arr| arr[1]}.reverse
      top_customers = y[0...t].map{|arr| arr[0]}
      best = {}
        top_customers.each do |id|
          best[id] = []
        end
        @se_instance.customers.all.each do |c|
          if top_customers.include?(c.id)
            best[c.id] << c
          end
        end
          return best.map{|k, v| v}.flatten
    end

    def top_merchant_for_customer(customer_id)
      invoices = []
      @se_instance.invoices.all.each do |invoice|
        invoices << invoice if invoice.customer_id == customer_id
      end
      invoice_items_per_invoice = {}
        invoices.each do |invoice|
          invoice_items_per_invoice[invoice] = []
        end
        @se_instance.invoice_items.all.each do |ii|
          invoice_items_per_invoice.each do |k, v|
            if ii.invoice_id == k.id
              invoice_items_per_invoice[k] << ii.quantity
            end
          end
        end
      final = []
        invoice_items_per_invoice.each do |k,v|
          final << [k.merchant_id, v.reduce(:+)]
        end
      merchant = final.sort_by{|arr| arr[1]}.reverse[0][0]
        @se_instance.merchants.all.each do |m|
          if m.id == merchant
            return m
          end
        end
    end

    def one_time_buyers
      successful_invoices = []
        @se_instance.transactions.all.each do |t|
          if t.result == "success"
            successful_invoices << t.invoice_id
          end
        end

      invoices = []
      @se_instance.invoices.all.each do |invoice|
        invoices << invoice if successful_invoices.include?(invoice.id)
      end
      x = invoices.chunk{|i| i.customer_id}.select{|arr| arr[1].count == 1}
      y = x.map{|arr| arr[0]}
      customers = []
        @se_instance.customers.all.each do |c|
          customers << c if y.include?(c.id)
        end
          return customers
    end

    def one_time_buyers_top_items
      otb = self.one_time_buyers
      otb_ids = otb.map{|c| c.id}
      successful_invoices = []
        @se_instance.transactions.all.each do |t|
          if t.result == "success"
            successful_invoices << t.invoice_id
          end
        end
      invoices = []
        @se_instance.invoices.all.each do |i|
          invoices << i if successful_invoices.include?(i.id)
        end
      invoices_from_otb = []
        invoices.each do |i|
          invoices_from_otb << i if otb_ids.include?(i.customer_id)
        end

      invoices_ids_from_otb = invoices_from_otb.map{|i| i.id}
      invoice_items = []
        @se_instance.invoice_items.all.each do |ii|
          invoice_items << ii if invoices_ids_from_otb.include?(ii.invoice_id)
        end
      ii_sorted_by_quantity = invoice_items.sort_by{|ii| ii.item_id}
      x = ii_sorted_by_quantity.chunk{|ii| ii.item_id}
      y = x.map{|k, v| [k, v.map{|ii| ii.quantity}] }
      z = y.map{|arr| [arr[0], arr[1].reduce(:+)]}.sort_by{|arr| arr[1]}.reverse[0][0]
        @se_instance.items.all.each do |item|
          return [item] if item.id == z
        end
     end

     def items_bought_in_year(customer_id, year)
       successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success" }.map{|t| t.invoice_id}
       successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
       customers_successful_invoices = successful_invoices.select{|i| i.customer_id == customer_id && i.created_at.to_s[0..3].to_i == year}
         if customers_successful_invoices.empty?
           return []
         else
           invoice_items = @se_instance.invoice_items.all.select{|ii| ii.invoice_id == customers_successful_invoices[0].id}.map{|ii| ii.item_id}
           items = []
             @se_instance.items.all.each do |i|
               items << i if invoice_items.include?(i.id)
             end
               return items.sort_by{|i| i.merchant_id}
         end
     end

    def highest_volume_items(customer_id)
      customer_invoices = @se_instance.invoices.all.select{|i| i.customer_id == customer_id}.map{|i| i.id}
      customer_invoice_items = @se_instance.invoice_items.all.select{|ii| customer_invoices.include?(ii.invoice_id)}
      max = customer_invoice_items.max_by{|ii| ii.quantity}.quantity
      top_invoice_items = customer_invoice_items.select{|ii| ii.quantity == max}
      item_ids = top_invoice_items.map{|ii| ii.item_id}
      top_items = @se_instance.items.all.select{|item| item_ids.include?(item.id)}
        return top_items.sort_by{|i|i.merchant_id}
    end

    def customers_with_unpaid_invoices#?
      unpaid_invoices = []
        @se_instance.invoices.all.each do |invoice|
          unpaid_invoices << invoice if invoice.is_paid_in_full? == false
        end
      unpaid_invoices_customer_ids = unpaid_invoices.map{|invoice| invoice.customer_id}
      customers = []
        @se_instance.customers.all.each do |c|
          customers << c if unpaid_invoices_customer_ids.include?(c.id)
        end
          return customers
    end

    def best_invoice_by_revenue
      successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success" }.map{|t| t.invoice_id}
      successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
      si = {}
        successful_invoices.each do |i|
          si[i] = []
        end
        @se_instance.invoice_items.all.each do |ii|
          si.each do |k, v|
            if ii.invoice_id == k.id
              v << ii
            end
          end
        end
          return si.map{|k, v| [k, v.map{|ii| ii.unit_price * ii.quantity}]}.map{|k,v| [k, v.reduce(:+)]}.sort_by{|arr| arr[1]}.reverse[0][0]
     end

     def best_invoice_by_quantity
       successful_transactions = @se_instance.transactions.all.select{|t| t.result == "success" }.map{|t| t.invoice_id}
       successful_invoices = @se_instance.invoices.all.select{|i| successful_transactions.include?(i.id)}
       si = {}
         successful_invoices.each do |i|
           si[i] = []
         end
         @se_instance.invoice_items.all.each do |ii|
           si.each do |k, v|
             if ii.invoice_id == k.id
               v << ii
             end
           end
         end
           return si.map{|k, v| [k, v.map{|ii| ii.quantity}]}.map{|k,v| [k, v.reduce(:+)]}.sort_by{|arr| arr[1]}.reverse[0][0]
     end

end
