module Riot
  class Config
    attr_accessor :macros_dir, :middleware_dir, :mock_with, :reporter, :alone
    
    def initialize
      @macros_dir     = 'test/riot/macros'
      @middleware_dir = 'test/riot/middleware'
      @mock_with      = nil
      @reporter       = :silent
      @alone          = false
    end
  end
end
