
require "pry"
require "csv"
require "table_print"


def valid_selection?(bag)
  ["1","2","3","4","5"].include?(bag)
end

def transaction_price_calculator(price, quantity)
  quantity.to_i * price.to_i.to_f
end

def bag_quanity_is_valid?(bag_quanity)
  (bag_quanity =~ /\d/) == 0
end

def calculate_amount_due(item_total, itemized_list)
   itemized_list.each do |item|
    puts  "Bag Purchased: [#{item[:item]}] Quanity Purchased: [#{item[:quantity]}] Total: [#{item[:total]}]"
  end
  puts "Transaction Total: $#{"%.2f"%item_total}"
  puts 'What is the amount tendered'
  amount_tendered = gets.chomp.to_i
  change_due = amount_tendered - item_total
  if change_due >= 0
    puts "Change due: $#{"%.2f"%change_due}"
  elsif amount_still_owed = change_due * -1
    puts "The customer still owes: $#{"%.2f"%amount_still_owed}"
  end
  puts Time.now.strftime("%m/%d/%Y")
  puts Time.now.strftime("%I:%M%p") 
end

def format_money(dollar_amount)
  "$#{"%.2f"%dollar_amount}"
end

@coffees = []


transaction_totals = []
transaction_for_manager=[]
transactions = []


puts "What would you like to do?  View sales data or ring up transactions?"
puts "For sales data type (S) for new transaction type (T)."
opening_command = gets.chomp

if opening_command.downcase == 't'
CSV.foreach('prices.csv', headers: true) do |row|
  coffee_types = {}
  number = row['Number']
  name = row['Name']
  sku = row['SKU']
  retail = row['Retail Price']
  purchasing = row['Purchasing Price']
  coffee_types = {number: number, coffee_name: name, sku: sku, retail_price: retail, purchase_price: purchasing}  
  @coffees << coffee_types
end
end
  @coffees.each do |coffee|
   puts "#{coffee[:number]}) #{coffee[:coffee_name]}: #{coffee[:retail_price]}"
end

all_sales = []
if opening_command.downcase == 's'
  CSV.foreach('sales_transactions.csv', headers: true) do |row|
    item = row['Item']
    date = row['Date']
    sku = row['SKU']
    quantity_purchased = row['Quanity']
    total_sales = row['Total Sales']
    cogs = row['COGS']
    sales_records = {item: item, date_sold: date, sku: sku, quantity_purchased: quantity_purchased, total_sales: total_sales, cogs: cogs}
    all_sales << sales_records
  end
end

if opening_command == 's'

  puts 'What date would you like to see a transaction for?'
  view_date =gets.chomp

  sale_total_for_day_specified = []
  total_cogs_for_date_specified =[]
  total_quanity_sold_for_date_specified = []


all_sales.each do |sale|
  if view_date == sale[:date_sold]
    sale_total_for_day_specified << sale[:total_sales].to_i
    total_cogs_for_date_specified << sale[:cogs].to_i
    total_quanity_sold_for_date_specified << sale[:quantity_purchased].to_i
  end
end

total_sale = sale_total_for_day_specified.inject() {|sum, sale| sum += sale}
total_cogs = total_cogs_for_date_specified.inject() {|sum, cogs| sum += cogs}
total_qty_purchased = total_quanity_sold_for_date_specified.inject() {|sum, qty| sum += qty}
net_profit = (total_sale - total_cogs)

puts "==========================="
puts "Sales Data: for #{view_date}"
puts "Total Sales: $#{total_sale}"
puts "Total Cost of Goods Sold: $#{total_cogs}"
puts "Quanity Sold: #{total_qty_purchased}"
puts "Net Profit: $#{net_profit}"
puts "==========================="

sales_for_date_specified =[]

all_sales.each do |sale|
  transactions_for_view_date = {}
    if view_date == sale[:date_sold]
      transactions_for_view_date = { 
        'Sale Date' => sale[:date_sold],
        'Item Sold' => sale[:item],
        'Quantity Sold' => sale[:quantity_purchased],
        'Sale Total' => sale[:total_sales],
      'Cost of Goods Sold' => sale[:cogs]
    }
    end
  sales_for_date_specified << transactions_for_view_date
  end
end
sales_for_date_specified.delete_if {|sale| sale.count == 0}

tp sales_for_date_specified

while opening_command.downcase == 't'
  puts 'Make a selection'
  coffee_bag_selected = gets.chomp

  if coffee_bag_selected.downcase == 'done'
    calculate_amount_due(@grand_total,transactions)
    break
  elsif valid_selection?(coffee_bag_selected)
    index = (coffee_bag_selected.to_i - 1)
    item = @coffees[index][:coffee_name]
    sku = @coffees[index][:sku]
    retail_price = @coffees[index][:retail_price]
    purchase_price = @coffees[index][:purchase_price]
    date_of_transaction = Time.now.strftime("%m/%d/%Y")

    puts item

    puts 'How many are being purchased'
    bag_quanity = gets.chomp
    
    if bag_quanity_is_valid?(bag_quanity)
      transaction_total = transaction_price_calculator(@coffees[index][:retail_price], bag_quanity)
      transaction_totals << transaction_total 

      @grand_total = transaction_totals.inject() {|sum, total| sum += total}
      puts format_money(@grand_total)


      transaction = {item: item,  quanity: bag_quanity, total: transaction_total}
      manager = { date: date_of_transaction, item: item, sku: sku, retail_price: retail_price, purchase_price: purchase_price, quanity: bag_quanity, transaction_total: transaction_total}  
      transactions << transaction
      
      transaction_for_manager << manager      
    else
      puts 'Invalid Quanity'
      break
    end
  else
    puts 'invadid selection exiting program'
    break
  end
end

items = {}

transaction_for_manager.each do |transaction|
  if items.has_key?(transaction[:item])
    items[transaction[:item]][:total_sales] += transaction[:transaction_total]
    items[transaction[:item]][:quanity] += transaction[:quanity].to_i
    items[transaction[:item]][:cogs] += (transaction[:purchase_price].to_i * transaction[:quanity].to_i)
  else  
    items[transaction[:item]] = {date_of_transaction: transaction[:date], total_sales: transaction[:transaction_total], sku: transaction[:sku], 
    quanity: transaction[:quanity].to_i, cogs: transaction[:purchase_price].to_i} 
  end 
end

CSV.open("sales_transactions.csv", "a+") do |csv|
  items.each do |key, data|
  csv <<  data.values.unshift(key)
  end
end