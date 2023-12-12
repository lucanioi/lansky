module Chatbot
  module Engines
    module AI
      module Prompts
        PROMPTS = {
          operations: [
            Prompts::Operations::Spent::PROMPTS,
            Prompts::Operations::GetBudget::PROMPTS,
            Prompts::Operations::SetBudget::PROMPTS,
            Prompts::Operations::Spending::PROMPTS,
            Prompts::Operations::Status::PROMPTS,
            Prompts::Operations::GetTimezone::PROMPTS,
            Prompts::Operations::GetCurrency::PROMPTS,
          ]
        }
      end
    end
  end
end
