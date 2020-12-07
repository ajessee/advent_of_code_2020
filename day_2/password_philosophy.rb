require 'pry-byebug'

class PasswordPhilosophy

  def initialize
    @passwords_array = File.read('passwords.txt').split("\n").map do |line|
      matches = line.match(/(.*?)[?<=\s](.*?)[?=\s](\w+)/)
      {
        no_of_instances: matches[1].split('-').map(&:to_i),
        letter_to_match: matches[2].tr(':', ''),
        password: matches[3]
      }
    end
    @original_number_of_valid_passwords = 0
    @number_of_valid_passwords = 0
  end

  # part 1 of challenge
  def original_number_of_valid_passwords
    @passwords_array.each do |password_object|
      letters_array = password_object[:password].chars.select { |letter| letter.downcase == password_object[:letter_to_match].downcase}
      valid_password = letters_array.count.between?(password_object[:no_of_instances][0], password_object[:no_of_instances][1])
      @original_number_of_valid_passwords += 1 if valid_password
    end
    success_message
  end

  # part 2 of challenge
  def number_of_valid_passwords
    @passwords_array.each do |password_object|
      letters_array = password_object[:password].chars
      first_index = (password_object[:no_of_instances][0] - 1)
      second_index = (password_object[:no_of_instances][1] - 1)
      first_letter_matches = letters_array[first_index].downcase == password_object[:letter_to_match].downcase
      second_letter_matches = letters_array[second_index].downcase == password_object[:letter_to_match].downcase
      valid_password = first_letter_matches && !second_letter_matches || !first_letter_matches && second_letter_matches
      @original_number_of_valid_passwords += 1 if valid_password
    end
    success_message
  end

  def success_message
    puts "Found #{@original_number_of_valid_passwords} valid passwords out of #{@passwords_array.length} total passwords"
  end

end

PasswordPhilosophy.new.number_of_valid_passwords
