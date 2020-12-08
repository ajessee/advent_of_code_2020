require 'pry-byebug'

arg1 = ARGV[0] ? ARGV[0].to_i : nil
arg2 = ARGV[1] ? ARGV[1].to_i : nil

class PassportProcessing

  def initialize
    @passports_array = File.read('passports.txt').split
  end

  def main_method
    # do work
  end

  def success_message
    puts ''
  end

  def failure_message
    puts ''
  end

end

PassportProcessing.new.main_method
