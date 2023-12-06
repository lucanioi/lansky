module Chatbot
  module Operations
    class Help < BaseOperation
      def execute
        <<~HELP
          Available Operations:

          *set budget <period> <amount>*
           _Sets the budget for the given period to the given amount.
           <period> could be 'january', 'today', 'this month', 'Thursday', etc_

          *get budget <period>*
           _Gets the budget for the given period. `budget` is an alias for `get budget`_

          *spent <amount> <category>*
           _Registers the given amount as spending to the given category_

          *spening <period>*
          _Returns the spending ovoerview for given period_

          *status*
           _Returns the budget status for the current period_

          *help*
           _Returns this help message_
        HELP
      end
    end
  end
end
