module Riot
  class IOReporter < Reporter
    def initialize(writer=STDOUT)
      super()
      @writer = writer
    end
    def puts(message) @writer.puts(message); end
    def print(message) @writer.print(message); end

    def line_info(line, file)
      line ? "(on line #{line} in #{file})" : ""
    end

    def results(time_taken)
      values = [passes, failures, errors, ("%0.6f" % time_taken)]
      puts "\n%d passes, %d failures, %d errors in %s seconds" % values
    end

    def format_error(e)
      format = []
      format << "    #{e.class.name} occurred"
      format << "#{e.to_s}"
      e.backtrace.each { |line| format << "      at #{line}" }

      format.join("\n")
    end

    begin
      raise LoadError if ENV["TM_MODE"]
      require 'rubygems'
      require 'term/ansicolor'
      include Term::ANSIColor
    rescue LoadError
      def green(str); str; end
      alias :red :green
      alias :yellow :green
    end
  end
end
