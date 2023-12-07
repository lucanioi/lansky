module Chatbot
  module Operations
    class Help < BaseOperation
      def execute
        <<~HELP
          Available Operations:

          *set budget <period> <amount>*
           _Sets the budget for the given period to the given amount._
           _<period> could be 'january', 'today', 'this month', 'Thursday', etc_

          *spent <amount> <category>*
           _Registers the given amount as spending to the given category_

          *spending <period>*
          _Returns the spending ovoerview for given period_

          *status*
           _Returns the budget status for the current period_

          *set timezone <timezone>*
           _Sets your current timezone_

          *set currency <currency>*
           _Sets your currency_

          *help*
           _Returns this help message_
        HELP
      end
    end
  end
end
