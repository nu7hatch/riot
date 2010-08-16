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
  
  context "with hashes" do
    setup { Riot::Assertion.new("test") { {:foo=>:bar, 1=>2, 2=>3} } }
    
    assertion_test_passes(%Q{when returned hash contains key :foo}) do
      topic.contains(:foo)
    end
    
    assertion_test_passes(%Q{when returned hash contains keys [1,2]}) do
      topic.contains([1,2])
    end
    
    assertion_test_fails("when returned hash do not contain key", %Q{expected hash {1=>2, 2=>3, :foo=>:bar} to contain keys [4, 5]}) do
      topic.contains([4,5])
    end
  end
end # A contains assertion macro
