
module Hellolisp

  module Interpreter

    module_function

    def interpret(input, context = nil)
      # puts "interpret \n  #{input} \n  #{context}"
      if context.nil?
        interpret(input, Context.library)
      elsif input.is_a?(Array)
        interpret_list(input, context)
      elsif input.is_a?(Numeric)
        input
      elsif input[0] == '"' && input[-1] == '"'
        input[1..-2]
      else
        context.get(input)
      end
    end

    def interpret_list(input, context = nil)
      # puts "interpret_list \n  #{input} \n  #{context}"
      if input.length == 0
        nil
      elsif Special.key?(input.first)
        Special.fetch(input.first).call(input, context)
      else
        list = input.map { |x| interpret(x, context) }
        if list.first.is_a?(Proc)
          list.first.call(list[1..-1])
        elsif list.first.nil?
          list.last
        else
          raise "undefined function `#{list.first}' in #{context}"
        end
      end
    end

    Special = {

      :'let' => -> (input, context) {
        interpret(input[2],
          input[1].reduce(context.birth) { |acc, x|
            acc.put(x[0], interpret(x[1], context))
          }
        )
      },

      :'lambda' => -> (input, context) {
        -> (args) {
          interpret(input[2],
            input[1].zip(args)
              .reduce(context.birth) { |acc, x|
                acc.put(x[0], x[1]) }
          )
        }
      },

      :'defun' => -> (input, context) {
        context.put(input[1],
          Special.fetch(:'lambda')
            .call(input[1..-1], context))
        nil
      },

      :'quote' => -> (input, context) {
        input[1]
      },

      :'if' => -> (input, context) {
        interpret(input[1], context) ?
          interpret(input[2], context) :
          interpret(input[3], context)
      }

    }

  end

end
