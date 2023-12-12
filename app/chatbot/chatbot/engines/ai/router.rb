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
          Route.new(operation:, params:)
        end

        private

        def operation
          @operation ||=
            OPERATIONS.fetch(operation_name) { raise UnknownOperation }
        end

        def ai_response
          @ai_response ||= ai.parse_operation(input: message)
        end

        def params
          ai_response[:args]
        end

        def operation_name
          return unless ai_response.present?

          ai_response[:operation]&.to_sym
        end

        def ai
          @ai ||= Lansky::AI.new(prompts: Prompts::PROMPTS)
        end

        attr_accessor :message
      end
    end
  end
end
