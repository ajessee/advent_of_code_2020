require 'pry-byebug'

arg1 = ARGV[0] ? ARGV[0].to_i : nil
arg2 = ARGV[1] ? ARGV[1].to_i : nil

class TobogganTrajectory

  def initialize
    @trees_array = File.read('trees.txt').split("\n")
    @horizontal_index = 0
    @number_of_trees_in_path = 0
    @line_length = nil
  end

  def find_trajectory
    @trees_array.each do |tree_string|
      @line_length ||= tree_string.length
      # reset index to modulo if index is greater than zero-adjusted line length
      @horizontal_index = @horizontal_index % @line_length if @horizontal_index > (@line_length - 1)
      # add to tree count if land on tree character
      @number_of_trees_in_path += 1 if tree_string[@horizontal_index] == '#'
      # increment by 3
      @horizontal_index += 3
    end
    success_message
  end

  def success_message
    puts "Found #{@number_of_trees_in_path} trees in path"
  end

  def failure_message
    puts ''
  end

end

TobogganTrajectory.new.find_trajectory
