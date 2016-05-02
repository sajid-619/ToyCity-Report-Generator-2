require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def start
	setup_files
	create_report
end

def create_report
	$report_file.puts print_sales_report_header # Print "Sales Report" in ascii art & Print today's date
	$report_file.puts(Time.now.strftime("%D"))
	$report_file.puts print_products_header # Print "Products" in ascii art
	print_products_selection
	$report_file.puts print_brands_header # Print "Brands" in ascii art
	initialize_brands_data_containers
	analyze_collect_brands_data
	print_all_brands_data
end

def add_line_separator(line_length = 30)
	return "*" * line_length
end

def add_line_return
	puts "\n"
end

def average(number)
	average = number / 2
	return "Average Sales Price: $#{average}"
end

def discount(num1, num2)
	num3 = (num1 - num2) / num1 * 100
	return "Average Discount: #{num3.round(2)}%"
end

def avg_brand_price(num_value1, num_value2)
	num_value3 = num_value1 / num_value2
	return "Average Price: $#{num_value3.round(2)}"
end

def average_lego_brand_price(number)
	average = number / 2
	return "Average Price: $#{average.round(2)}"
end

def average_nano_brand_price(number)
	average = number / 1
	return "Average Price: $#{average.round(2)}"
end

def print_sales_report_header
" ####                                  #####
#     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####
#        #  #  #      #      #         #     # #      #    # #    # #    #   #
 #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #
      # ###### #      #           #    #   #   #      #####  #    # #####    #
#     # #    # #      #      #    #    #    #  #      #      #    # #   #    #
 #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #
********************************************************************************"
end

def print_products_header
"                     _            _
                    | |          | |
 _ __  _ __ ___   __| |_   _  ___| |_ ___
| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|
| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\
| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/
| |
|_|                                       "
end

def print_brands_header
" _                         _
| |                       | |
| |__  _ __ __ _ _ __   __| |___
| '_ \\| '__/ _` | '_ \\ / _` / __|
| |_) | | | (_| | | | | (_| \\__ \\
|_.__/|_|  \\__,_|_| |_|\\__,_|___/
                                   "
end

def print_products_selection
	$products_hash["items"].each do |toy|
		$report_file.puts toy["title"]
		$report_file.puts(add_line_separator)
		retail_price = toy["full-price"].to_f
		$report_file.puts "Retail Price: $#{toy["full-price"]}"
		$report_file.puts "Total Purchases: #{toy["purchases"].count}"
		total_sales = toy["purchases"][0]["price"].to_f + toy["purchases"][1]["price"].to_f
		$report_file.puts "Total Sales: $#{total_sales}"
		average_price = total_sales / 2
		$report_file.puts average(total_sales)
		$report_file.puts discount(retail_price, average_price)
		$report_file.puts(add_line_return)
	end
end

def initialize_brands_data_containers
	$lego = {brand: "",count: 0, price_sum: 0, sales: 0, revenue: 0}
	$nano_block = {brand: "",count: 0, price_sum: 0, sales: 0, revenue: 0}
end

def analyze_collect_brands_data
	collect_lego_brand_data
	collect_nano_brand_data
end

def collect_lego_brand_data
	$products_hash["items"].each do |brand|
		if brand["brand"] == "LEGO"
			$lego[:brand] = brand["brand"] # assign brand name, ignoring duplicate
			$lego[:count] += brand["stock"] # cycle through the data and combine stock values
			$lego[:price_sum] += brand["full-price"].to_f
			$lego[:revenue] += brand["purchases"][0]["price"].to_f + brand["purchases"][1]["price"].to_f # calculate price sum
			$lego[:sales] += brand["purchases"].count # cycle through and calculate number of purchases
		end
	end
end

def collect_nano_brand_data
	$products_hash["items"].each do |brand|
		if brand["brand"] == "Nano Blocks"
			$nano_block[:brand] = brand["brand"]
			$nano_block[:count] += brand["stock"]
			$nano_block[:price_sum] += brand["full-price"].to_f
			$nano_block[:revenue] +=  brand["purchases"][0]["price"] + brand["purchases"][1]["price"].to_f
			$nano_block[:sales] += brand["purchases"].count
		end
	end
end

def print_all_brands_data
	print_lego_brand_data
	$report_file.puts(add_line_return)
	print_nano_brand_data
end

def print_lego_brand_data
	$report_file.puts($lego[:brand])
	$report_file.puts(add_line_separator)
	$report_file.puts("Total Inventory: #{$lego[:count]}")
	$report_file.puts(average_lego_brand_price($lego[:price_sum]))
	$report_file.puts("Total Revenue: $#{$lego[:revenue].round(2)}")
end

def print_nano_brand_data
	$report_file.puts($nano_block[:brand])
	$report_file.puts(add_line_separator)
	$report_file.puts("Total Inventory: #{$nano_block[:count]}")
	$report_file.puts(average_nano_brand_price($nano_block[:price_sum]))
	$report_file.puts("Total Revenue: $#{$nano_block[:revenue]}")
end

start
