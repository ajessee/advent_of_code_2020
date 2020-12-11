require 'pry-byebug'
class BinaryBoarding

  def initialize
    @boarding_passes_array = File.read('boarding_passes.txt').split
    @highest_seat_id = nil
    @missing_seat = nil
    @seat_ids_array = nil
  end

  def find_seat_info
    find_seat_ids
    find_highest_seat_id
    find_missing_seat
    success_message
  end

  def find_highest_seat_id
    @highest_seat_id = @seat_ids_array.reduce { |acum, id| acum > id ? acum : id }
  end

  def find_missing_seat
    @seat_ids_array.each_with_index do |seat, index|
      next_seat_doesnt_match = seat + 1 != @seat_ids_array[index + 1]
      last_index = index + 1 == @seat_ids_array.length
      if next_seat_doesnt_match && !last_index
        @missing_seat = (seat + 1)
      end
    end
  end

  def parse_boarding_pass(boarding_pass)
    rows_array = *(0..127)
    columns_array = *(0..7)
    boarding_pass_array = boarding_pass.chars
    boarding_pass_array.each_with_index do |letter, index|
      if index.between?(0, 6)
        rows_array = split_array(letter, rows_array)
      else
        columns_array = split_array(letter, columns_array)
      end
    end
    row = rows_array[0]
    column = columns_array[0]
    [row, column]
  end

  def split_array(letter, input_array)
    lower_half, upper_half = input_array.each_slice((input_array.length / 2.0).round).to_a
    case letter
    # upper half
    when 'B', 'R'
      upper_half
    # lower half
    when 'F', 'L'
      lower_half
    end
  end

  def find_seat_ids
    seat_ids = @boarding_passes_array.map do |boarding_pass|
      row, column = parse_boarding_pass(boarding_pass)
      (row * 8) + column
    end
    @seat_ids_array = seat_ids.sort
  end

  def success_message
    puts "Highest seat ID: #{@highest_seat_id}"
    puts "Missing seat ID: #{@missing_seat}"
  end

end

BinaryBoarding.new.find_seat_info
