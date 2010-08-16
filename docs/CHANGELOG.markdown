## Changelog

*0.11.3*

* Modified `matches` assertion macro to treat actual as a string before executing regular expression comparison. [jaknowlden]

    asserts("a number") { 42 }.matches(/\d+/)
    # same as
    asserts("a number as string") { "42" }.matches(/\d+/)

*0.11.2*

* [ISSUE] Options were not nesting. Now fixed. [jaknowlden]

*0.11.1*

* Middleware can now acts more like you would expect. Middleware now know the next neighbor in the chain and can do stuff to the context before and after the user-defined context is prepared. Removes support for the handle? method. Now we act more like a Rack app. [jaknowlden]

    class MyMiddleware < Riot::ContextMiddleware
      register
      
      def call(context)
        context.setup { "fooberries" }

        middleware.call(context)

        context.hookup { "furberries" } if context.option(:barns)
      end
    end

*0.11.0*

* Added option to Context#setup which puts the specific setup block at the beginning of the setups to be called for a context. Also useful for middlewares. [jaknowlden]

    context "Foo" do
      setup { puts "called second" }
      setup { puts "called third" }
      setup(true) { puts "called first" }
    end # Foo

* Added idea of options for a context. This is another feature picked up from riot-rails work. [jaknowlden]

Essentially, these are useful for middlewares. For instance, if you wanted to tell a middleware that was looking for a "transactional" option before running code in a transaction block, you might do this:

    context User do
      set :transactional, true
    end # User

The middleware might do something with it:

    class TransactionalMiddleware < Riot::ContextMiddleware
      register

      def handle?(context) context.option(:transactional) == true; end

      def prepare(context)
        # transactional stuff
      end
    end # TransactionalMiddleware

You can call set as many times as you like

    context User do
      set :transactional, true
      set :foo, :bar
    end

* ContextMiddleware: a construction pattern that allows for custom code to be applied to any context given that the middleware chooses to. This is something I started building into riot-rails and decided it was useful enough to just put it into riot itself. [jaknowlden]

If, for instance, you wanted to add a setup with some stuff only if the context description was equal to "Your Mom":

    class YourMomMiddleware < Riot::ContextMiddleware
      register

      def handle?(context)
        context.description == "Your Mom"
      end

      def prepare(context)
        context.setup do
          "your mom is the topic"
        end
      end
    end # YourMomMiddleware

*0.10.13*

* Helpers are now run with other setups, not separately. Which means you could use a helper in a setup. [jaknowlden]

    context "Foo" do
      helper(:user) { User.new }
      setup do
        Baz.new(:user => user) # :)
      end
    end # Foo

* Correctly report non-RR assertion failures and errors when RR is used [vandrijevik]

    context "Foo.bar" do
      asserts("baz is called") do
        mock(Foo).baz
        raise RuntimeError.new("oh noes")
      end
    end

  would previously return [:fail, "baz() Called 0 times. Expected 1 times."], and will now
  correctly return [:error, #<RuntimeError: oh noes>]

* Recording description as is. Providing #detailed_description for proper behavior [jaknowlden]

    foo_context = context(Foo) {}
    bar_context = foo_context.context(Bar) {}
    bar_context.description
    => Bar
    bar_context.detailed_description
    => "Foo Bar"

* No longer assuming topic when no block provided to an assertion. Instead, assuming block fails by default. Use `asserts_topic` only now. [jaknowlden]

    context "foo" do
      setup { "bar" }
      asserts_topic.kind_of(String)
      asserts("topic").kind_of(String) # Will fail since block returns `false`
      asserts("topic").equals(false) # Will actually pass :)
    end

*0.10.12*

* Recognizing file and line number of an assertion declaration on failure [vandrijevik]

* RR support in Riot [vandrijevik,jaknowlden]

    # teststrap.rb
    require 'riot'
    require 'riot/rr'
    
    # your-test.rb
    context "foo" do
      asserts("failure due to not calling hello") { mock!.hello {"world"} } # actually fails
    end

* Added Riot::Message to make messages in macros easier to write [jaknowlden]

    def evaluate(actual, expected)
      # ...
      expected == actual pass(new_message.received(expected)) ? fail(expected(expected).not(actual))
      # ...
    end

* Added responds_to as a respond_to alias [jaknowlden]

* Added the equivalent_to macro to compare case equality (===). equals is now (==) [jaknowlden]

* Assuming RootContext if nil parent provided. Added Context#parent to the API [jaknowlden]

    Riot::Context.new("Hi", nil) {}.parent.class
    => Riot::RootContext

*0.10.11*

* Context#asserts_topic now takes an optional description [gabrielg, jaknowlden]

    asserts_topic.exists
    asserts_topic("some kind of description").exists

* Added not! assertion macro [gabrielg, jaknowlden]

    setup { User.new(:funny? => false) }
    asserts(:funny?).not!

* Added Context#hookup to add some setup code to an already defined topic [jaknowlden]

    context "yo mama" do
      setup { YoMama.new }
      # ...
      context "is cool" do
        hookup { topic.do_something_involving_state }
        asserts_topic.kind_of?(YoMama)
      end
    end

* Added Riot.alone! mode to ensure Riot.run is not run at-exit [jaknowlden]

    Riot.alone!
    Riot.run

  This will still print output unless you also Riot.silently!

* Returning non-zero status at-exit when tests don't pass [gabrielg, jaknowlden]

*0.10.10*

* Passing assertion macros can now return a custom message [dasch, jaknowlden]

    def evaluate(actual, *expectings)
      1 == 1 ? pass("1 does equal 1") : fail("1 does not equal 1 in this universe")
    end

* Removing Context#extend_assertions and related code [jaknowlden]

* Allow the use of symbolic descriptions as shorthands for sending the message to the topic [dasch]

    setup { "foo" }
    asserts(:upcase).equals("FOO")

* Added AssertionMacro and #register for macros [jaknowlden, splattael]

    module My
      class CustomThingAssertion < Riot::AssertionMacro
        register :custom_thing
        expects_exception!

        def evaluate(actual, *expectings)
          # ...
        end
      end
      
      Riot::Assertion.register_macro :custom_thing, CustomThingAssertion
    end

* Replace IOReporter#say with #puts. Also add #print. [splattael]

    class SomeNewReporter < IOReporter
      def pass
        puts "I PASSED"
      end

      def fail
        print "F"
      end
      # ...
    end

*0.10.9 and before*

See [commit log](http://github.com/thumblemonks/riot/commits/master)
