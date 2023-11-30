module Chatbot
  module Operations
    class Help < BaseOperation
      def execute
        <<~HELP
          Available Operations:

          *set budget <month> <amount>*
           _Sets the budget for the given month to the given amount_

          *get budget <month>*
           _Gets the budget for the given month. `budget` is an alias for `get budget`_

          *spent <amount> <category>*
           _Registers the given amount as spending to the given category_

          *status*
           _Returns the budget status for the current period (month)_

          *help*
           _Returns this help message_
        HELP
      end
    end
  end
end
