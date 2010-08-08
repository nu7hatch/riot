$:.unshift(File.dirname(__FILE__) + "/../lib/")
require 'riot'

require 'riot/reporters/io'
require 'riot/reporters/story'
require 'riot/reporters/verbose'
require 'riot/reporters/silent'
require 'riot/reporters/dots'

Riot.verbose

Riot.dots if ENV["TM_MODE"]

module Riot
  module AssertionTestContextMacros

    def assertion_test_passes(description, success_message="", &block)
      context(description) do
        setup(&block)
        setup { topic.run(Riot::Situation.new) }
        asserts("pass") { topic.first }.equals(:pass)
        asserts("success message") { topic.last }.equals(success_message)
      end
    end

    def assertion_test_fails(description, failure_message, &block)
      context(description) do
        setup(&block)
        asserts("failure") { topic.run(Riot::Situation.new).first }.equals(:fail)
        asserts("failure message") { topic.run(Riot::Situation.new)[1] }.equals(failure_message)
      end
    end

  end # AssertionTestContextMacros
end # Riot

Riot::Context.instance_eval { include Riot::AssertionTestContextMacros }

class MockReporter < Riot::Reporter
  def pass(description, message); end
  def fail(description, message, line, file); end
  def error(description, e); end
  def results; end
end

class ColorHelper
  require 'rubygems'
  require 'term/ansicolor'
  extend Term::ANSIColor
end
