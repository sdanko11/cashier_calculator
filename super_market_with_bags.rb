# if opening_command.downcase == 'transaction'
#   CSV.foreach('sales_transactions.csv', headers: true) do |row|
#     sales_records = {}
#     item = row['Item']
#     date = row['Date']
#     sku = row['SKU']
#     quantity_purchased = row['Quanity']
#     cogs = row['COGS']
#     sales_records = {iten: item, date_sold: date, sku: sku, quantity_purchased: quantity_purchased, cogs: cogs}  
#     puts sales_records.each do |transaction|
#     puts transaction
#   end
# end
# end


require "pry"
require "csv"

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

# CSV.foreach('prices.csv', headers: true) do |row|
#   coffee_types = {}
#   number = row['Number']
#   name = row['Name']
#   sku = row['SKU']
#   retail = row['Retail Price']
#   purchasing = row['Purchasing Price']
#   coffee_types = {number: number, coffee_name: name, sku: sku, retail_price: retail, purchase_price: purchasing}  
#   @coffees << coffee_types
# end


# @coffees.each do |coffee|
#   puts "#{coffee[:number]}) #{coffee[:coffee_name]}: #{coffee[:retail_price]}"
# end

# coffee_bags = {
#   "1" => {price: 5.00, type: "Light Bag"},
#   "2" => {price: 7.50, type: "Medium_Bag"},
#   "3" => {price: 9.75, type: "Bold_Bag"}
# }

transaction_totals = []
transaction_for_manager=[]
transactions = []
# puts 'Enter key to see sales data'
#   sales_key=gets.chomp
#   if sales_key =='1111'
#     puts 'here is your sales data'
#   end
puts "What would you like to do?  View sales data or ring up transactions?"
puts "For sales data type 'S' for new transaction type 'T'"
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



# Item,Date,Total Sales,SKU,Quanity,COGS

if opening_command == 's'
puts 'What date would you like to see a transaction for?'
view_date =gets.chomp
sale_total_for_day_specified = []
total_cogs_for_date_specified =[]
total_quanity_sold_for_date_specified = []
# sales_records_for_date_specified = []
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

end

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

        # price = item[:price]

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

# populate_csv(items, sales_data.csv)


 # if transaction[:item] == 'House Special'
  #   items[:House_special] = {transaction[:transaction_total], transaction[:item], transaction[:retail_price], transaction[:purchase_price]}
  # end
# transaction_for_manager.each do |transaction|
#   items = {}
#   if transaction[:item] == "House Special"
#    items[:quantity_purchased] = transaction[:quantity]
#    items[:item_name] = transaction[:item]
#    items[:retail_price] = items[:retail_price]
#    quantity_purchased << items
#   end
# end



# transaction_for_manager.each do |item|
#   if item[:item] == "House Special" 
#     house_blend_total << item[:retail_price]
#   end
# end



# require "pry"

# def valid_selection?(bag)
#   ["1","2","3"].include?(bag)
# end

# def transaction_price_calculator(price, quantity)
#   quantity.to_i * price
# end

# def bag_quanity_is_valid?(bag_quanity)
#   (bag_quanity =~ /\d/) == 0
# end

# def calculate_amount_due(item_total, itemized_list)
#   itemized_list.each do |item|
#     puts  "#{item[:item][:type]} #{item[:quantity]} #{item[:total]}"
#   end
#   puts "Transaction Total: $#{"%.2f"%item_total}"
#   puts 'What is the amount tendered'
#   amount_tendered = gets.chomp.to_i
#   change_due = amount_tendered - item_total
#   if change_due >= 0
#     puts "Change due: $#{"%.2f"%change_due}"
#   elsif amount_still_owed = change_due * -1
#     puts "The customer still owes: $#{"%.2f"%amount_still_owed}"
#   end
#   puts Time.now.strftime("%m/%d/%Y")
#   puts Time.now.strftime("%I:%M%p") 
# end

# def format_money(dollar_amount)
#   "$#{"%.2f"%dollar_amount}"
# end


# puts 'Welcome to James coffee emporium'
# puts ''
# puts '1) Add item - $5.00 - Light Bag'
# puts '2) Add item - $7.50 - Medium Bag'
# puts '3) Add item - $9.75 - Bold Bag'

# # coffee_bags = {Light_Bag: 5.00, Medium_Bag: 7.50, Bold_Bag: 9.75}

# coffee_bags = {
#   "1" => {price: 5.00, type: "Light Bag"},
#   "2" => {price: 7.50, type: "Medium_Bag"},
#   "3" => {price: 9.75, type: "Bold_Bag"}
# }

# # puts "Make a Selection"
# transaction_totals = []
# transactions = []


# while true
#   puts 'Make a selection'
#   coffee_bag_selected = gets.chomp

#   if coffee_bag_selected.downcase == 'done'
#     calculate_amount_due(@grand_total,transactions)
#     break
#   elsif valid_selection?(coffee_bag_selected)
#     item = coffee_bags[coffee_bag_selected]
#     price = item[:price]

#     puts 'How many are being purchased'
#     bag_quanity = gets.chomp
    
#     if bag_quanity_is_valid?(bag_quanity)
#       transaction_total = transaction_price_calculator(price, bag_quanity)
#       transaction_totals << transaction_total 

#       @grand_total = transaction_totals.inject() {|sum, total| sum += total}
#       puts format_money(@grand_total)


#       transaction = {item: item, quantity: bag_quanity, total: transaction_total}
#       transactions << transaction

      
#     else
#       puts 'Invalid Quanity'
#       break
#     end
#   else
#     puts 'invadid selection exiting program'
#     break
#   end
# end







# def number_check(number)
#   number =~ /^\d+(\.\d{0,2})?$/
# end

# def is_the_coffeee_selected_valid(coffee_selection)
#   coffee_selection == "1" || coffee_selection == "2" || coffee_selection == "3"
# end





# # def change_due(amount_tendered, total_cost)
# #   change = (amount_tendered - total_cost)
# #   if change >= 0
# #   puts "=========================="
# #   puts "Change Due: #{change}"
# #   puts "=========================="
# #   elsif change <= -1
# #   amount_still_owed = change * -1
# #   puts "=========================="
# #   puts "The customer still owes: $#{amount_still_owed}"
# #   puts "=========================="
# #   end
# # end
# # purchased=[]
# # item_total=[]

# # while true
# #   puts 'Make a Selection'
# #   coffee_selection = gets.chomp
# #   if coffee_selection == "1" || coffee_selection == "2" || coffee_selection == "3"
# #     puts coffee_bags[coffee_selection][:type] 
# #     puts 'How many bags would you like to purchase'
# #     bags_purchased = gets.chomp
# #     transaction_sum = coffee_bags[coffee_selection][:price] * bags_purchased.to_i
# #     item_total.push(transaction_sum)
# #     total_cost = item_total.inject() {|sum, total| sum += total}
# #     puts total_cost
# #   elsif ![1, 2, 3, 'done'].include?(coffee_selection) 
# #     puts "Invalid Coffee Selection Exiting Program"
# #     break
# #   elsif coffee_selection == 'done' ||  coffee_selection == 'Done' 
# #     break
# #   end
# # end



# # if (coffee_selection == 'Done' || coffee_selection == 'done') && total_cost.to_i > 0
# #   puts "=========================="
# #   puts "Total Price: #{total_cost}"
# #   puts purchased
# #   puts "=========================="
# #   puts 'What is the amount tendered?'
# #   amount_tendered=gets.chomp.to_i.to_f
# # end  
# # if (amount_tendered.to_s =~ /^\d+(\.\d{0,2})?$/) == 0 && amount_tendered.to_i > 0
# #   change_due(amount_tendered, total_cost) 
# # end










