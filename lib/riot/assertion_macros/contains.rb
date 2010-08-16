module Riot
  # Asserts that array contains given elements or string contains given words.
  #
  #   asserts("test") { ["foo", "bar", 69] }.contains(["bar", 69])
  #   should("test") { "This is sparta!" }.contains(["This", "sparta"])
  class ContainsMacro < AssertionMacro
    register :contains

    def evaluate(actual, expected)
      require 'set'
      orig_actual = actual
      actual = actual.split(/\s+/) if actual.is_a?(String)
      contains = (Set.new(expected) - Set.new(actual)).empty?
      contains ? pass : if orig_actual.is_a?(String)
        fail(expected_message.sentence(orig_actual).to_contain(expected))
      else
        fail(expected_message.elements(orig_actual).to_contain(expected))
      end
    end
  end
end
