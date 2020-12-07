require 'pry-byebug'

set_size = ARGV[0] ? ARGV[0].to_i : nil
sum_to_check = ARGV[1] ? ARGV[1].to_i : nil

class ReportRepair

  def initialize
    @expense_report_array = File.read('expense_report.txt').split.map(&:to_i).shuffle
    @total_numbers_tested = 0
    @unique_sets_tested = 0
    @sum_to_check = nil
    @set_size = nil
    @match = false
    @start_time = nil
    @end_time = nil
    @set_array = []
  end

  def product_of_set
    @match ? @set_array.reduce(&:*) : nil
  end

  def run_time
    @start_time && @end_time ? @end_time - @start_time : nil
  end

  def success_message
    puts ''
    puts "You were looking for a combination of #{@set_size} numbers that add up to #{@sum_to_check}"
    puts "We found a matching set: #{@set_array.sort.join(', ')}"
    puts "The product of the numbers in that set is: #{product_of_set}"
    puts "Unique sets tested: #{@unique_sets_tested}"
    puts "Total numbers tested: #{@total_numbers_tested}"
    puts ''
    puts "Script took #{run_time} seconds to run"
    puts ''
  end

  def failure_message
    puts "You were looking for a combination of #{@set_size} numbers that add up to #{@sum_to_check}"
    puts "We could not find a matching set."
    puts "Unique sets tested: #{@unique_sets_tested}"
    puts "Total numbers tested: #{@total_numbers_tested}"
    puts ''
    puts "Script took #{run_time} seconds to run"
    puts ''
  end


  def sum_exists(set_size, sum_to_check)
    @start_time = Time.now
    @set_size = set_size || 2
    @sum_to_check = sum_to_check || 2020
    # This is where the magic happens.
    # The array combination() method returns a nested array containing sets of unique combinations of all the numbers in the original array. 
    # The set size is determined by the integer you pass in as argument.
    # However, the time complexity of this increases significantly with larger set sizes.
    # Apparently, the time complexity is (n choose k)
    array_of_sets = Array(@expense_report_array).combination(set_size)
    array_of_sets.each do |unique_set|
      @match = unique_set.reduce(&:+) == sum_to_check
      @unique_sets_tested += 1
      @total_numbers_tested += set_size
      next unless @match

      @end_time = Time.now
      @set_array = unique_set
      break
    end
    @match ? success_message : failure_message
  end

end

ReportRepair.new.sum_exists(set_size, sum_to_check)
