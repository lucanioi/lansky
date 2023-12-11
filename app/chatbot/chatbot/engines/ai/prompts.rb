module Chatbot
  module Engines
    module AI
      module Prompts
        PROMPTS = {
          operations: [
            Prompts::Operations::Spent::PROMPTS,
            Prompts::Operations::GetBudget::PROMPTS,
            Prompts::Operations::SetBudget::PROMPTS,
          ]
        }
      end
    end
  end
end
