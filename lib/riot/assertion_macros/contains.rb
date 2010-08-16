module Riot
  # Asserts that array contains given elements or string contains given words.
  #
  #   asserts("test") { ["foo", "bar", 69] }.contains(["bar", 69])
  #   should("test") { "This is sparta!" }.contains(["This", "sparta"])
  class ContainsMacro < AssertionMacro
    register :contains

    def evaluate(actual, expected)
      require 'set'
      expected.is_a?(Array) or expected = [expected]
      case actual
      when String
        actual_arr = actual.split(/\s+/)
        contains = (Set.new(expected) - Set.new(actual_arr)).empty?
        contains ? pass : fail(expected_message.sentence(actual).to_contain(expected))
      when Array
        contains = (Set.new(expected) - Set.new(actual)).empty?
        contains ? pass : fail(expected_message.elements(actual).to_contain(expected))
      when Hash
        puts "#{expected.inspect} => #{actual.keys.inspect}"
        contains = (Set.new(expected) - Set.new(actual.keys)).empty?
        contains ? pass : fail(expected_message.hash(actual).to_contain_keys(expected))
      else
        pass
      end
    end
  end
end
