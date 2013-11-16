def error_message
  puts "Error invalid amount of money exiting program"
end

def number_check(number)
    number =~ /^\d+(\.\d{0,2})?$/
end

def letter_check(word)
  word =~ /[a-zA-Z]/
end

def total_calculation(amount_tendered, total_price)
  amount_due = amount_tendered.to_f - total_price
  if amount_due >= 0
      puts '==================='
      puts"Change Due: $#{"%.2f"%amount_due}"
  else 
    amount_still_owed = amount_due * -1
      puts puts '==================='
      puts "The customer still owes: $#{"%.2f"%amount_still_owed}"
  end
end

item_total=[]
number_check=0
puts "What is the price of the item?"
item_price=gets.chomp

while true
  if number_check(item_price) == 0
    item_total.push(item_price.to_f)
      total_price = item_total.inject() {|sum, price| sum + price }
        puts  "Total Price: $#{"%.2f"%total_price}"
          puts "What is the sale price"
            item_price=gets.chomp
  else number_check(item_price) == nil 
    break
  end
end

if (item_total.length > 0 && letter_check(item_price) != 0) || item_price == "Done" || item_price == "done"
  puts "=============="
    puts "Total Price: $#{"%.2f"%total_price}"
      puts "Here are your list of items:"
        puts item_total
          puts "What is the amount tendered?"
            amount_tendered=gets.chomp.to_s
end
  if number_check(amount_tendered) == 0
    total_calculation(amount_tendered, total_price)
      puts Time.now.strftime("%m/%d/%Y")
        puts Time.now.strftime("%I:%M%p") 
  else 
    number_check(amount_tendered) == nil 
      error_message
end






