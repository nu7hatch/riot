module Riot
  # Asserts that the result of the test is nil.
  #
  #   asserts("test") { nil }.nil
  #   should("test") { nil }.nil
  class NilMacro < AssertionMacro
    register :nil

    def evaluate(actual)
      actual.nil? ? pass("is nil") : fail(expected_message.nil.not(actual))
    end
  end
end
