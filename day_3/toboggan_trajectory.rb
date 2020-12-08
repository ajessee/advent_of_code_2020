require 'pry-byebug'

slope_sets = ARGV[0] ? ARGV[0].to_i : nil

class TobogganTrajectory

  def initialize
    @trees_array = File.read('trees.txt').split("\n")
    @slope_sets = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
    @tree_count_array = []
  end

  def get_slope_sets_trajectory_sum(slope_sets)
    @slope_sets = slope_sets || @slope_sets
    @slope_sets.each do |set|
      find_trajectory(*set)
    end
    success_message
  end

  def find_trajectory(slope_x, slope_y)
    @slope_x = slope_x
    @slope_y = slope_y
    @slope_x_memo = 0
    @number_of_trees_in_path = 0
    @trees_array.each_with_index do |tree_string, index|
      # if modulo of index and slope_y is 1, skip iteration
      next if index % slope_y == 1

      @line_length ||= tree_string.length
      # reset index to modulo if index is greater than zero-adjusted line length
      @slope_x_memo = @slope_x_memo % @line_length if @slope_x_memo > (@line_length - 1)
      # add to tree count if land on tree character
      @number_of_trees_in_path += 1 if tree_string[@slope_x_memo] == '#'
      # increment by 3
      @slope_x_memo += @slope_x
    end
    @tree_count_array << @number_of_trees_in_path
  end

  def success_message
    @tree_count_array.each_with_index do |count, index|
      puts "Found #{count} trees in path for set #{@slope_sets[index]}"
    end
    puts "Product of tree counts: #{@tree_count_array.reduce(&:*)}"
  end
end

TobogganTrajectory.new.get_slope_sets_trajectory_sum(slope_sets)