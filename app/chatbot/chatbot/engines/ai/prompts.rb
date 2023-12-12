module Chatbot
  module Engines
    module AI
      module Prompts
        PROMPTS = {
          operations: [
            Prompts::Operations::GetBudget::PROMPTS,
            Prompts::Operations::SetBudget::PROMPTS,
            Prompts::Operations::GetTimezone::PROMPTS,
            Prompts::Operations::SetTimezone::PROMPTS,
            Prompts::Operations::GetCurrency::PROMPTS,
            Prompts::Operations::SetCurrency::PROMPTS,
            Prompts::Operations::Spent::PROMPTS,
            Prompts::Operations::Recovered::PROMPTS,
            Prompts::Operations::Status::PROMPTS,
            Prompts::Operations::Spending::PROMPTS,
          ]
        }
      end
    end
  end
end
