require 'teststrap'

context "A Riot module" do 
  asserts "have helper to change underscored word to class name" do 
    Riot.classify('module/underscored_word') 
  end.equals('Module::UnderscoredWord')
  
  asserts "allows to load extenstions (eg. macros or middlewares) from specified dir" do 
    Riot.load_custom_extensions(File.dirname(__FILE__)+'/../samples/')
    RIOT_SAMPLE_EXTENSION
  end
end
