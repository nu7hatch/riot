require 'riot/reporter'
require 'riot/middleware'
require 'riot/context'
require 'riot/situation'
require 'riot/runnable'
require 'riot/assertion'
require 'riot/assertion_macro'
require 'riot/config'

module Riot
  def self.configure(&block)
    yield config
  end
  
  def self.config
    @config ||= Config.new
  end
  
  def self.run
    load_mock
    load_custom_extensions(@config.macros_dir)
    load_custom_extensions(@config.middleware_dir)
    the_reporter = load_reporter.new
    the_reporter.summarize do
      root_contexts.each { |ctx| ctx.run(the_reporter) }
    end
    the_reporter
  end
  
  def self.load_reporter
    r = @config.reporter || :silent
    if r.is_a?(Symbol) or r.is_a?(String)
      begin
        require "riot/reporters/#{r}"
        # eval is te fastest way to get namespaded consts. It's much faster 
        # than const_get chain. 
        reporter_class = eval("Riot::#{classify(r)}Reporter") 
      rescue LoadError
        raise LoadError, "Riot `#{r}` reporter not found" 
      end  
    elsif r.is_a?(Class)
      reporter_class = r
    else
      raise ArgumentError, "Invalid reporter"
    end
    reporter_class
  end
  
  def self.load_mock
    if m = @config.mock_with
      begin
        require "riot/mocks/#{m}"
      rescue LoadError
        begin 
          require "riot-#{m}-mocks"
        rescue
          begin 
            require "riot-#{m}"
          rescue
            raise LoadError, "Riot does not supports `#{r}` mocks"
          end
        end 
      end
    end
  end
  
  def self.load_custom_extensions(dir)
    if File.exists?(dir)
      Dir[File.join(dir, '*.rb')].each do |file|
        require file      
      end
    end
  end
  
  def self.context(description, context_class = Context, &definition)
    (root_contexts << context_class.new(description, &definition)).last
  end

  def self.root_contexts; @root_contexts ||= []; end

  # This means you don't want to see any output from Riot. A "quiet riot" as Envy5 put it.
  def self.silently!
    deprecated("Riot#dots", "1.0", "Riot.config.reporter = :silent")
    Riot.config.reporter = :silent
  end
  
  def self.silently?
    deprecated("Riot#dots", "1.0", "Riot.config.reporter")
    !!Riot.config.reporter == :silent 
  end

  # This means you don't want Riot to run tests for you. You will execute Riot.run manually.
  def self.alone!
    deprecated("Riot#dots", "1.0", "Riot.config.alone = true")
    Riot.config.alone = true 
  end
  
  def self.alone? 
    deprecated("Riot#dots", "1.0", "Riot.config.alone")
    !!Riot.config.alone 
  end

  def self.reporter=(reporter_class)
    deprecated("Riot#dots", "1.0", "Riot.config.reporter=")
    Riot.config.reporter = reporter_class
  end

  def self.reporter
    deprecated("Riot#dots", "1.0", "Riot.config.reporter")
    load_reporter
  end

  # TODO: make this a flag that DotMatrix and Story respect and cause them to print errors/failures
  def self.verbose 
    deprecated("Riot#dots", "1.0", "Riot.config.reporter = :verbose")
    Riot.config.reporter = :verbose
  end
  
  def self.dots
    deprecated("Riot#dots", "1.0", "Riot.config.reporter = :dots")
    Riot.config.reporter = :dots
  end

  # Helper method for making class name from underscored word
  #
  #   classify('my_underscored_class_name') # => 'MyUnderscoredClassName'
  def self.classify(word)
    word.to_s.split('/').map do |mod| 
      mod.to_s.split('_').each { |part| part[0] = part[0].chr.upcase }.join
    end.join('::')
  end
  
  def self.deprecated(method_name, horizon="1.0", use=nil)
    msg = "#{method_name} is deprecated and will be removed from Riot #{horizon}."
    msg << "Use #{use} insead."
    puts msg
  end

  at_exit { exit(run.success?) unless Riot.alone? }
end # Riot

class Object
  def context(description, context_class = Riot::Context, &definition)
    Riot.context(description, context_class, &definition)
  end
  alias_method :describe, :context
end
