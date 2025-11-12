#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/basket'
require_relative 'lib/product'
require_relative 'lib/delivery_calculator'
require_relative 'lib/offer_manager'

PRODUCT_CATALOGUE = {
  'R01' => Product.new('R01', 32.95),  # Red Widget
  'G01' => Product.new('G01', 24.95),  # Green Widget
  'B01' => Product.new('B01', 7.95)    # Blue Widget
}.freeze

def display_products
  puts "\n" + "="*50
  puts "ACME WIDGET CO - PRODUCT CATALOGUE"
  puts "="*50
  puts "Code | Product      | Price"
  puts "-"*30
  puts "R01  | Red Widget   | $32.95"
  puts "G01  | Green Widget | $24.95"
  puts "B01  | Blue Widget  | $7.95"
  puts "\nDelivery Rules:"
  puts "• Orders under $50: $4.95 delivery"
  puts "• Orders $50-$89.99: $2.95 delivery"
  puts "• Orders $90+: FREE delivery"
  puts "\nSpecial Offers:"
  puts "• Buy one Red Widget, get the second half price!"
  puts "="*50
end

def interactive_mode
  basket = Basket.new(PRODUCT_CATALOGUE)
  
  puts "\n" + "="*50
  puts "INTERACTIVE BASKET MODE"
  puts "="*50
  puts "Commands:"
  puts "1. add <product_code> - Add product to basket"
  puts "2. total - Show current total"
  puts "3. summary - Show basket contents"
  puts "4. clear - Clear basket"
  puts "5. help - Show this help"
  puts "6. exit - Exit interactive mode"
  puts "="*50
  
  loop do
    print "\nBasket> "
    input = gets.chomp.split
    command = input[0]&.downcase
    
    case command
    when 'add'
      if input[1]
        begin
          basket.add(input[1].upcase)
          puts "Added #{input[1].upcase} to basket"
        rescue ArgumentError => e
          puts "Error: #{e.message}"
        end
      else
        puts "Usage: add <product_code>"
      end
      
    when 'total'
      puts "Current total: $#{'%.2f' % basket.total}"
      
    when 'summary'
      summary = basket.items_summary
      if summary.empty?
        puts "Basket is empty"
      else
        puts "Basket contents:"
        summary.each { |code, count| puts "  #{code}: #{count}" }
      end
      
    when 'clear'
      basket.clear
      puts "Basket cleared"
      
    when 'help'
      puts "Commands: add, total, summary, clear, help, exit"
      
    when 'exit'
      puts "Goodbye!"
      break
      
    else
      puts "Unknown command. Type 'help' for available commands."
    end
  end
end

def main
  display_products
  
  puts "\n" + "="*50
  puts "Welcome to Acme Widget Co's Shopping Basket!"
  
  interactive_mode
end

# Run the main program if this file is executed directly
main if __FILE__ == $PROGRAM_NAME