require 'riot/message'

module Riot
  # The base class for all assertion macros.
  #
  # == Using macros
  #
  # Macros are applied to the return value of assertions. For example, the
  # `empty` macro asserts that the value is, well, empty, e.g.
  #
  #     asserts(:comments).empty?
  #
  # 
  # == Writing your own macros
  #
  # Macros are added by subclassing {AssertionMacro}. For example, here's
  # the implementation of `empty`:
  #
  #     class EmptyMacro < AssertionMacro
  #       register :empty
  #        
  #       def evaluate(actual)
  #         actual.length == 0 ? pass : fail(expected_message(actual).to_be_empty)
  #       end
  #     end
  #
  class AssertionMacro
    class << self
      # Whether the macro expects an exception to be thrown.
      attr_reader :expects_exception

      # The default macro.
      def default
        @default_macro ||= new
      end

      # Specify that the macro expects an exception to be thrown by the assertion.
      def expects_exception!
        @expects_exception = true
      end

      # Register the macro under the given name.
      #
      # @param [Symbol] name the name of the macro
      def register(name)
        Assertion.register_macro name, self
      end
    end

    attr_accessor :line, :file

    def pass(message=nil) 
      [:pass, message.to_s]
    end
    
    def fail(message) 
      [:fail, message.to_s, line, file]
    end
    
    def error(e) 
      [:error, e]
    end

    def expects_exception?
      self.class.expects_exception
    end

    def evaluate(actual)
      actual ? pass : fail("Expected non-false but got #{actual.inspect} instead")
    end

    # Messaging

    def new_message(*phrases) 
      Message.new(*phrases)
    end
    
    def should_have_message(*phrases) 
      new_message.should_have(*phrases)
    end
    
    def expected_message(*phrases) 
      new_message.expected(*phrases)
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'assertion_macros/*.rb')].each {|assertion_macro|
  require assertion_macro
}

