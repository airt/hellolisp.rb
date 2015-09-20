
module Hellolisp

  class Context

    def initialize(scope, parent = nil)
      @scope  = scope   # Hash
      @parent = parent  # Context
    end

    def self.library
      self.new(Library.clone)
    end

    def birth
      Context.new({}, self)
    end

    def get(id)
      if @scope.key?(id)
        @scope.fetch(id)
      elsif !@parent.nil?
        @parent.get(id)
      else
        raise "undefined symbol `#{id}' in #{self}"
      end
    end

    def put(id, val)
      @scope[id] = val
      self
    end

    def to_s
      @scope == Library ? 'Library' : @scope.to_s
    end

  end

end
