require 'riot/reporters/story'

module Riot
  class VerboseStoryReporter < StoryReporter
    def error(description, e)
      super
      puts red(format_error(e))
    end
  end
  VerboseReporter = VerboseStoryReporter
end
