module SpecHelpers
  module OperationIntegration
    def run_operation(user:, message:)
      Chatbot::Engine.run(user:, message:)
    end
  end
end
