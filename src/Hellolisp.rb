
module Hellolisp

  $:.unshift File.expand_path('..', __FILE__)

  require 'Parser'
  require 'Context'
  require 'Library'
  require 'Interpreter'

  module_function

  def eval(input)
    Interpreter::interpret(Parser::parse(input))
  end

  if __FILE__ == $0

    if ARGV[0].nil?
      puts 'need filepath'
      exit(1)
    end
    input = File.read(ARGV[0])
    eval(input)

  end

end
