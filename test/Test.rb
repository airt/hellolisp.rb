
module Hellolisp

  require 'test/unit'
  require File.expand_path('../../src/Hellolisp.rb', __FILE__)

  class HLTest < Test::Unit::TestCase

    # def setup
    # end

    # def teardown
    # end

    def test_eval
      code = <<-'EOC'
        (defun foo (x) (+ x 1))
        ((lambda (x) (* x (foo x))) 2)
      EOC
      actual   = Hellolisp::eval(code)
      expected = 6
      assert_equal(expected, actual)
    end

    def test_interpreter_interpret_let
      code = <<-'EOC'
        (let ((x 1)
              (y 2)
              (z 3))
          (+ x (* y z)))
      EOC
      list     = Parser::parse(code)
      actual   = Interpreter::interpret(list)
      expected = 7
      assert_equal(expected, actual)
    end

    def test_interpreter_interpret_lambda
      code = <<-'EOC'
        ((lambda (func x)
            (func x (+ x 1)))
          (lambda (x y)
            (+ x y))
          512)
      EOC
      list     = Parser::parse(code)
      actual   = Interpreter::interpret(list)
      expected = 1025
      assert_equal(expected, actual)
    end

    def test_interpreter_interpret_defun
      code = <<-'EOC'
        (defun foo (x) (+ x 1))
        (foo 2)
      EOC
      list     = Parser::parse(code)
      actual   = Interpreter::interpret(list)
      expected = 3
      assert_equal(expected, actual)
    end

    def test_interpreter_interpret_quote
      code = """
        (car '(1 2))
      """
      list     = Parser::parse(code)
      actual   = Interpreter::interpret(list)
      expected = 1
      assert_equal(expected, actual)
    end

    def test_interpreter_interpret_if
      code = <<-'EOC'
        (if nil (+ 1 (+ 2 3)) (+ 2 3))
      EOC
      list     = Parser::parse(code)
      actual   = Interpreter::interpret(list)
      expected = 5
      assert_equal(expected, actual)
    end

    def test_context
      actual1 = Context.library.birth.get(:car).call(['a', 'b', 'c'])
      actual2 = Context.library.birth.put(:n, 1024).get(:n)
      assert_equal(['a', 1024], [actual1, actual2])
    end

    def test_library
      actual1 = Library.fetch(:car).call([['a', 'b', 'c']])
      actual2 = Library.fetch(:cdr).call([['a', 'b', 'c']])
      assert_equal(['a', ['b', 'c']], [actual1, actual2])
    end

    def test_parser_parse
      code = <<-'EOC'
        (foo 0 (bar e (+ 1 1.2)))
      EOC
      actual   = Parser::parse(code)
      expected = [:foo, 0, [:bar, :e, [:'+', 1, 1.2]]]
      assert_equal(expected, actual)
    end

  end

end
