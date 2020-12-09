require 'pry-byebug'

arg1 = ARGV[0] ? ARGV[0].to_i : nil
arg2 = ARGV[1] ? ARGV[1].to_i : nil

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
    @valid_fields = %i[byr iyr eyr hgt hcl ecl pid cid]
    @required_fields = @valid_fields - %i[cid]
    @number_of_valid_passports = 0
  end

  def number_of_valid_passports
    @passports_array.each do |passport_obj|
      required = @required_fields.sort == passport_obj.keys.sort
      valid = @valid_fields.sort == passport_obj.keys.sort
      @number_of_valid_passports += 1 if required || valid
    end
    success_message
  end

  def success_message
    puts "Number of valid passports found: #{@number_of_valid_passports} out of #{@passports_array.length}"
  end

  def failure_message
    puts ''
  end

end

PassportProcessing.new.number_of_valid_passports
