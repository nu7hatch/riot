require 'teststrap'

context "A contains assertion macro" do
  context "with arrays" do 
    setup { Riot::Assertion.new("test") { ["foo", "bar", 69] } }
    
    assertion_test_passes(%Q{when returned array contains "foo"}) do
      topic.contains("foo")
    end

    assertion_test_passes(%Q{when returned array contains "foo" and "bar"}) do
      topic.contains(["foo", "bar"])
    end

    assertion_test_fails("when returned array do not contain", %Q{expected elements ["foo", "bar", 69] to contain ["spam", "eggs"]}) do
      topic.contains(["spam", "eggs"])
    end
  end
  
  context "with strings" do
    setup { Riot::Assertion.new("test") { "This is sparta!" } }
    
    assertion_test_passes(%Q{when returned string contains "This"}) do
      topic.contains("This")
    end
    
    assertion_test_passes(%Q{when returned string contains "This"}) do
      topic.contains(["This", "sparta!"])
    end
    
    assertion_test_fails("when returned string do not contain", %Q{expected sentence "This is sparta!" to contain ["spam", "eggs"]}) do
      topic.contains(["spam", "eggs"])
    end
  end
end # A contains assertion macro
