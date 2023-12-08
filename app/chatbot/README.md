### Operation Class Convention
`Operations` refer to all queries and commands that are availble to the user
through the Chatbot.

```ruby
# There's some metaprogramming going on with operation and params. For every new
# operation, a corresponding params class should be created with the same class
# name like below:

module Chatbot
  module Operations
    class SomeOperation
      # there should be a declaration of params available in the operation
      params :month, :amount_cents

      def run
        # month and amount_cents, as declared above, become available as
        # methods in this class. `user` is also available in the instance.
        #
        # the `execute` method must return a string as a reply to be
        # shown to the end user.
      end
    end
  end
end

module Chatbot
  module Params
    class SomeOperation < BaseParams
      # The corresponding params object should expose an interface that match
      # the parameters declared with the `params` keyword in the operation class

      def month
        # attribute reader `message` is available in classes that inherit
        # from BaseParams
        @month ||= extract_month(message)
      end

      def amount_cents
        @amount_cents ||= extract_amount(message)
      end
    end
  end
end

# the usage is as follows:
Chatbot::Operations::SomeOperation.new(
  user: user,
  message: 'some operation 1000 euros whatever'
).execute
# => Returns a string reply
```
