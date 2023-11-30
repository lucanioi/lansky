module Chatbot
  module Operations
    class Help < BaseOperation
      def execute
        <<~HELP
         `set budget <month> <amount>`: Sets the budget for the given month to the given amount
         `get budget <month>`: Gets the budget for the given month. `budget` is an alias for `get budget`
         `spent <amount> <category>`: Registers the given amount as spending to the given category
         `status`: Returns the budget status for the current period (month)
         `help`: Returns this help message
        HELP
      end
    end
  end
end
