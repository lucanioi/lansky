module Chatbot
  module Operations
    class Help < BaseOperation
      def execute
        <<~HELP
         <strong>set budget <month> <amount></strong>
          Sets the budget for the given month to the given amount
         <strong>get budget <month></strong>
         Gets the budget for the given month. `budget` is an alias for `get budget`
         <strong>spent <amount> <category></strong>
         Registers the given amount as spending to the given category
         <strong>status</strong>
         Returns the budget status for the current period (month)
         <strong>help</strong>
         Returns this help message
        HELP
      end
    end
  end
end
