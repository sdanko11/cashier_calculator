require "pry"

def valid_selection?(bag)
  ["1","2","3"].include?(bag)
end

def transaction_price_calculator(price, quantity)
  quantity.to_i * price
end

def bag_quanity_is_valid?(bag_quanity)
  (bag_quanity =~ /\d/) == 0
end

def calculate_amount_due(item_total, itemized_list)
  itemized_list.each do |item|
    puts  "#{item[:item]} #{item[:quantity]} #{item[:total]}"
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


puts 'Welcome to James coffee emporium'
puts ''
puts '1) Add item - $5.00 - Light Bag'
puts '2) Add item - $7.50 - Medium Bag'
puts '3) Add item - $9.75 - Bold Bag'

# coffee_bags = {Light_Bag: 5.00, Medium_Bag: 7.50, Bold_Bag: 9.75}

coffee_bags = {
  "1" => {price: 5.00, type: "Light Bag"},
  "2" => {price: 7.50, type: "Medium_Bag"},
  "3" => {price: 9.75, type: "Bold_Bag"}
}

# puts "Make a Selection"
transaction_totals = []
transactions = []


while true
  puts 'Make a selection'
  coffee_bag_selected = gets.chomp

  if coffee_bag_selected.downcase == 'done'
    calculate_amount_due(@grand_total,transactions)
    break
  elsif valid_selection?(coffee_bag_selected)
    item = coffee_bags[coffee_bag_selected]
    price = item[:price]

    puts 'How many are being purchased'
    bag_quanity = gets.chomp
    
    if bag_quanity_is_valid?(bag_quanity)
      transaction_total = transaction_price_calculator(price, bag_quanity)
      transaction_totals << transaction_total 

      @grand_total = transaction_totals.inject() {|sum, total| sum += total}
      puts format_money(@grand_total)


      transaction = {item: item, quantity: bag_quanity, total: transaction_total}
      transactions << transaction
       
    else
      puts 'Invalid Quanity'
      break
    end
  else
    puts 'invadid selection exiting program'
    break
  end
end




