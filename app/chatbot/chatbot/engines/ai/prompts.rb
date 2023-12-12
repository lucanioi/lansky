module Chatbot
  module Engines
    module AI
      module Prompts
        PROMPT = {
          operations: [
            Prompts::Operations::GetBudget::PROMPT,
            Prompts::Operations::SetBudget::PROMPT,
            Prompts::Operations::GetTimezone::PROMPT,
            Prompts::Operations::SetTimezone::PROMPT,
            Prompts::Operations::GetCurrency::PROMPT,
            Prompts::Operations::SetCurrency::PROMPT,
            Prompts::Operations::Spent::PROMPT,
            Prompts::Operations::Recovered::PROMPT,
            Prompts::Operations::Status::PROMPT,
            Prompts::Operations::Spending::PROMPT,
          ]
        }
      end
    end
  end
end
