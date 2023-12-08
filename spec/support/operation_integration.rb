module SpecHelpers
  module OperationIntegration
    def run_operation(user:, message:)
      Chatbot::Engine.run(user: user, message: message)
    end
  end
end
