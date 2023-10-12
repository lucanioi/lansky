module Webhooks
  class ProcessMessage
    include Service

    SET_BUDGET = /set budget/

    def call
      command = parse_command

      return Service::Result.new(value: 'no comprendo') if command.nil?

      command.execute
    end

    private

    def parse_command
      case message
      when SET_BUDGET then Chatbot::Commands::SetBudget.new(message)
      end
    end

    attr_accessor :message
  end
end
