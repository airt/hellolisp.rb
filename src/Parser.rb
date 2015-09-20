
module Hellolisp

  module Parser

    module_function

    def parse(input)
      parenthesize(tokenize(input))
    end

    def tokenize(input)
      input.split('"')
        .map.with_index { |item, index|
          if index.odd?
            # in string
            '"' + item + '"'
          else
            # out of string
            item.gsub('(', ' ( ')
                .gsub(')', ' ) ')
                .strip
                .split(/\s+/)
          end
        }.flatten
    end

    def parenthesize(input)
      ret = []
      loop do
        t = input.shift
        case t
        when nil
          return ret.length == 1 ? ret.last : ret
        when '('
          ret << parenthesize(input)
        when ')'
          return ret
        when "'"
          if input.first == '('
            ret << [:quote] + parenthesize(input)
          else
            raise "unexpected #{input.first} after '"
          end
        else
          ret << categorize(t)
        end
      end
      ret
    end

    def categorize(t)
      case t
      when /^-?(?:[1-9]\d*|0)$/
        t.to_i
      when /^-?(?:[1-9]\d*|0)\.[0-9]+$/
        t.to_f
      else
        t.to_sym
      end
    end

  end

end
