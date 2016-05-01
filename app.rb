require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

# Print today's date
puts Time.now.strftime("Today's Date: %d/%m/%Y")

puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "


# For each product in the data set:
  # Print the name of the toy
  # Print the retail price of the toy
  # Calculate and print the total number of purchases
  # Calculate and print the total amount of sales
  # Calculate and print the average price the toy sold for
  # Calculate and print the average discount (% or $) based off the average sales price

def get_product(toy)
  product = {
    title: toy["title"],
    retail_price: toy["full-price"].to_f,
    purchases_number: toy['purchases'].length,
    total_sales: 0
  }
  toy["purchases"].each do |purchase|
    product[:total_sales] += purchase["price"].to_f
  end
  return product
end

def print_separator
  puts "********************"
end

def print_blank_line
  print "\n"
end

def print_product(product)
  print_blank_line
  puts product[:title]
  print_separator
  puts "Retail Price: $#{product[:retail_price]}"
  puts "Total Purchases: #{product[:purchases_number]}"
  puts "Total Sales: $#{product[:total_sales]}"
  average_price = product[:total_sales] / product[:purchases_number]
  average_discount = product[:retail_price] - average_price
  average_discount_percentage = (average_discount * 100 / product[:retail_price]).round(2)
  puts "Average Price: $#{average_price}"
  puts "Average Discount: $#{average_discount}"
  puts "Average Discount Percentage: #{average_discount_percentage}%"
  print_separator
end

brands = {}
products_hash["items"].each do |toy|
  product = get_product(toy)
  print_product(product)
  brand_title = toy["brand"]
  brands[brand_title] = {stock: 0, prices: [], total_sales: []} if brands[brand_title].nil?
  brands[brand_title][:stock] += toy["stock"].to_i
  brands[brand_title][:prices].push(product[:retail_price])
  brands[brand_title][:total_sales].push(product[:total_sales])
end
print_blank_line

	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts

# For each brand in the data set:
  # Print the name of the brand
  # Count and print the number of the brand's toys we stock
  # Calculate and print the average price of the brand's toys
  # Calculate and print the total revenue of all the brand's toy sales combined

brands.each do |title, value|
  puts title
  print_separator
  puts "Number of Products: #{value[:stock]}"
  average_price = (value[:prices].reduce(:+) / value[:prices].length).round(2)
  puts "Average Product Price: $#{average_price}"
  total_sales = value[:total_sales].reduce(:+).round(2)
  puts "Total Sales: $#{total_sales}"
  print_blank_line
end
