module Chatbot
  module Engines
    module AI
      class Router
        include Runnable

        UnknownOperation = Class.new(Lansky::DisplayableError)

        OPERATIONS = {
          set_budget: Chatbot::Operations::SetBudget,
          get_budget: Chatbot::Operations::GetBudget,
          spent: Chatbot::Operations::Spent,
          recovered: Chatbot::Operations::Recovered,
          status: Chatbot::Operations::Status,
          help: Chatbot::Operations::Help,
          spending: Chatbot::Operations::Spending,
          set_timezone: Chatbot::Operations::SetTimezone,
          get_timezone: Chatbot::Operations::GetTimezone,
          set_currency: Chatbot::Operations::SetCurrency,
          get_currency: Chatbot::Operations::GetCurrency,
        }.freeze

        def run
          operation = find_operation

          raise UnknownOperation unless operation

          Route.new(user:, operation:, params:)
        end

        private

        def find_operation
          ai_response[:operation]
        end

        def params
          return unless find_operation

          params = ai_response[:args]

          if find_operation.params.include?(:period) && !params[:period]
            params[:period] = :month
          end
        end

        def ai_response
          @ai_response ||= ai.parse_operation(input: message)
        end

        def ai
          @ai ||= Lansky::AI.new
        end

        attr_accessor :user, :message
      end
    end
  end
end
