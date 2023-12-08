module Chatbot
  module Engines
    module Classic
      class Router
        include Runnable

        UnknownOperation = Class.new(Lansky::DisplayableError)

        SET_BUDGET = /^set budget/
        GET_BUDGET = /^get budget|^budget/
        SPENT      = /^spent/
        RECOVERED  = /^recovered/
        STATUS     = /^status/
        HELP       = /^help/
        SPENDING   = /^spending/
        SET_TZ     = /^set timezone/
        GET_TZ     = /^get timezone|^timezone/
        SET_CUR    = /^set currency/
        GET_CUR    = /^get currency|^currency/

        def run
          operation = find_operation

          raise UnknownOperation unless operation

          Chatbot::Route.new(user:, operation:, params:)
        end

        private

        def find_operation
          case normalized_message
          when SET_BUDGET then Chatbot::Operations::SetBudget
          when GET_BUDGET then Chatbot::Operations::GetBudget
          when SPENT      then Chatbot::Operations::Spent
          when STATUS     then Chatbot::Operations::Status
          when HELP       then Chatbot::Operations::Help
          when SPENDING   then Chatbot::Operations::Spending
          when SET_TZ     then Chatbot::Operations::SetTimezone
          when GET_TZ     then Chatbot::Operations::GetTimezone
          when SET_CUR    then Chatbot::Operations::SetCurrency
          when GET_CUR    then Chatbot::Operations::GetCurrency
          when RECOVERED  then Chatbot::Operations::Recovered
          end
        end

        def find_param_parser
          case normalized_message
          when SET_BUDGET then Parsers::SetBudget
          when GET_BUDGET then Parsers::GetBudget
          when SPENT      then Parsers::Spent
          when SPENDING   then Parsers::Spending
          when SET_TZ     then Parsers::SetTimezone
          when SET_CUR    then Parsers::SetCurrency
          when RECOVERED  then Parsers::Recovered
          end
        end

        def params
          return {} unless find_param_parser

          find_param_parser.new(normalized_message).to_h
        end

        def normalized_message
          message.downcase.strip
        end

        attr_accessor :user, :message
      end
    end
  end
end
