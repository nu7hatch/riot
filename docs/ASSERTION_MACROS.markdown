## Assertion macros

List of available assertion macros. 

### any

Asserts the result has items.

    asserts("an array") { [1] }.any
    asserts("a hash") { {:name => 'washington'} }.any
    
### assigns

Asserts that an instance variable is defined for the result of the assertion. 
Value of instance variable is expected to not be nil.

    setup { User.new(:email => "foo@bar.baz") }
    topic.assigns(:email)

If a value is provided in addition to the variable name, the actual value of the instance variable
must equal the expected value.

    setup { User.new(:email => "foo@bar.baz") }
    topic.assigns(:email, "foo@bar.baz")
    
### contains

Asserts that array contains given elements or string contains given words.
    
    asserts("test") { ["foo", "bar", 69] }.contains(["bar", 69])
    should("test") { "This is sparta!" }.contains(["This", "sparta"])
    
### empty

Asserts the result is empty.

    asserts("a string") { "" }.empty
    asserts("an array") { [] }.empty
    asserts("a hash") { Hash.new }.empty
    
### equals

Asserts that the result of the test equals the expected value. Using the +==+ operator to assert
equality.

    asserts("test") { "foo" }.equals("foo")
    should("test") { "foo" }.equals("foo")
    asserts("test") { "foo" }.equals { "foo" }
    
### equivalent_to

Asserts that the result of the test is equivalent to the expected value. Using the +===+ operator.

    asserts("test") { "foo" }.equivalent_to(String)
    should("test") { "foo" }.equivalent_to("foo")
    asserts("test") { "foo" }.equivalent_to { "foo" }

Underneath the hood, this assertion macro says:

    expected === actual

### exists

Asserts that the result of the test is a non-nil value. This is useful in the case where you don't want
to translate the result of the test into a boolean value.

    asserts("test") { "foo" }.exists
    should("test") { 123 }.exists
    asserts("test") { "" }.exists
    asserts("test") { nil }.exists # This would fail

### includes

Asserts the result contains the expected element.

    asserts("a string") { "world" }.includes('o')
    asserts("an array") { [1,2,3] }.includes(2)
    asserts("a range") { (1..15) }.includes(10)

### kind_of

Asserts that the result of the test is an object that is a kind of the expected type.

    asserts("test") { "foo" }.kind_of(String)
    should("test") { "foo" }.kind_of(String)

### matches

Asserts that the result of the test equals matches against the proved expression.

    asserts("test") { "12345" }.matches(/\d+/)
    should("test") { "12345" }.matches(/\d+/)

### nil

Asserts that the result of the test is nil.

    asserts("test") { nil }.nil
    should("test") { nil }.nil

### not_borat

Asserts the result of the test is a non-truthy value. Read the following assertions in the way Borat
learned about humor:

    asserts("you are funny") { false }.not!
    should("be funny") { nil }.not!

Thusly, Borat would say "You are funny ... not!" The above two assertions would pass because the values
are non-truthy.

### raises

Asserts that the test raises the expected Exception

    asserts("test") { raise My::Exception }.raises(My::Exception)
    should("test") { raise My::Exception }.raises(My::Exception)

You can also check to see if the provided message equals or matches your expectations. The message
from the actual raised exception will be converted to a string before any comparison is executed.

    asserts("test") { raise My::Exception, "Foo" }.raises(My::Exception, "Foo")
    asserts("test") { raise My::Exception, "Foo Bar" }.raises(My::Exception, /Bar/)

### respond_to

Asserts that the result of the test is an object that responds to the given method.

    asserts("test") { "foo" }.respond_to(:to_s)
    should("test") { "foo" }.respond_to(:to_s)

### same_elements

Asserts that two arrays contain the same elements, the same number of times.

    asserts("test") { ["foo", "bar"] }.same_elements(["bar", "foo"])
    should("test") { ["foo", "bar"] }.same_elements(["bar", "foo"])

### size

Asserts that result's size is as expected. Expected size can be specified as
a number or a range.

    asserts("a string") { 'washington' }.size(9..12)
    asserts("an array") { [1, 2, 3] }.size(3)
    asserts("a hash") { {:name => 'washington'} }.size(1)
  
