module Riot
  class Reporter
    attr_accessor :passes, :failures, :errors, :current_context
    def initialize
      @passes = @failures = @errors = 0
      @current_context = ""
    end

    def success?
      (@failures + @errors) == 0
    end
    
    def summarize(&block)
      started = Time.now
      yield
    ensure
      results(Time.now - started)
    end

    def describe_context(context)
      @current_context = context
    end

    def report(description, response)
      code, result = *response
      case code
      when :pass then
        @passes += 1
        pass(description, result)
      when :fail then
        @failures += 1
        message, line, file = *response[1..-1]
        fail(description, message, line, file)
      when :error then
        @errors += 1
        error(description, result)
      end
    end

    def new(*args, &block)
      self
    end
  end # Reporter
end # Riot
