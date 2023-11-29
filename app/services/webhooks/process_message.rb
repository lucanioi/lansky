module Webhooks
  class ProcessMessage
    include Service

    SET_BUDGET = /^set budget/
    GET_BUDGET = /^get budget|^budget /
    SPENT      = /^spent/

    TRIGGER_ERROR = /^trigger error/

    def call
      command = parse_command

      return Service::Result.new(value: 'no comprendo') if command.nil?

      command.new(user:, message: normalized_message).execute
    end

    private

    def parse_command
      case normalized_message
      when SET_BUDGET then Chatbot::Commands::SetBudget
      when GET_BUDGET then Chatbot::Commands::GetBudget
      when SPENT      then Chatbot::Commands::Spent
      when TRIGGER_ERROR then (raise 'error triggered')
      end
    end

    def user
      Users::FindOrCreate.call(phone: phone_number).value
    end

    def normalized_message
      message.downcase.strip
    end

    attr_accessor :message, :phone_number
  end
end
