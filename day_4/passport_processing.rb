require 'pry-byebug'

validate_values = ARGV[0] ? ARGV[0] == 'true' : false

class PassportProcessing

  def initialize
    @passports_array = File.read('passports.txt').split(/\n{2,}/).map do |line|
      passport_obj = {}
      new_line_array = line.tr("\n", ' ').split
      new_line_array.each do |new_line|
        match = new_line.match(/(.*?)[?<=\:](.*)/)
        passport_obj[match[1].to_sym] = match[2]
      end
      passport_obj
    end
    @valid_fields = %i[byr iyr eyr hgt hcl ecl pid cid].sort
    @required_fields = @valid_fields - %i[cid]
    @number_of_valid_passports = 0
  end

  def validate(key, value)
    case key
    when :byr
      # byr (Birth Year) - four digits; at least 1920 and at most 2002.
      value.length == 4 && value.to_i.between?(1920, 2002)
    when :iyr
      # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
      value.length == 4 && value.to_i.between?(2010, 2020)
    when :eyr
      # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
      value.length == 4 && value.to_i.between?(2020, 2030)
    when :hgt
      # hgt (Height) - a number followed by either cm or in:
      match = value.match(/(\d*cm|\d*in)/)
      if match
        height_unit_array = match[1].split(/(?<=\d)(?=[A-Za-z])/)
        # If cm, the number must be at least 150 and at most 193.
        if height_unit_array[1] == 'cm'
          height_unit_array[0].to_i.between?(150, 193)
          # If in, the number must be at least 59 and at most 76.
        else
          height_unit_array[0].to_i.between?(59, 76)
        end
      else
        false
      end
    when :hcl
      # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
      match = value.match(/(\#{1})([(0-9|a-f)]{6})/)
      match && match[1] == value[0] && match[2] == value[1..-1]
    when :ecl
      # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
      %w[amb blu brn gry grn hzl oth].include?(value)
    when :pid
      # pid (Passport ID) - a nine-digit number, including leading zeroes.
      match = value.match(/([0-9]{9})/)
      match && match[1] == value
    when :cid
      # cid (Country ID) - ignored, missing or not.
      true
    else
      false
    end
  end

  def number_of_valid_passports(validate_values)
    @passports_array.each do |passport_obj|
      valid_fields = passport_obj.keys.sort == @required_fields || passport_obj.keys.sort == @valid_fields
      valid_values = true
      passport_obj.each do |key, value|
        valid_values = validate(key, value)
        break unless valid_values
      end
      if validate_values
        @number_of_valid_passports += 1 if valid_fields && valid_values
      elsif valid_fields
        @number_of_valid_passports += 1
      end
    end
    success_message
  end

  def success_message
    puts "Number of valid passports found: #{@number_of_valid_passports} out of #{@passports_array.length}"
  end

end

PassportProcessing.new.number_of_valid_passports(validate_values)

# For part 1, run: ruby passport_processing.rb false
# For part 2, run: ruby passport_processing.rb true
