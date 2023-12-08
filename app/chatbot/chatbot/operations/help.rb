module Chatbot
  module Operations
    class Help < Base
      def run
        <<~HELP
          Commands:

          *set budget <period> <amount>*
           _Define budget for 'january', 'today', 'this month', 'Thursday', etc._

          *spent <amount> <category>*
           _Log spending amount under a category._

          *recovered <amount> <category>*
           _Log recovered amount under a category._

          *spending <period>*
           _Show spending summary for a period._

          *status*
           _Display current budget status._

          *set timezone <timezone>*
           _Update your timezone._

          *set currency <currency>*
           _Change your currency._

          *help*
           _Get this help message._

          Tip: Type 'budget', 'timezone', or 'currency' to view current settings.
        HELP
      end
    end
  end
end
