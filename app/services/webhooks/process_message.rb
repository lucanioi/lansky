module Webhooks
  class ProcessMessage
    include Service

    SET_BUDGET = /^set budget/
    GET_BUDGET = /^get budget|^budget /
    SPENT      = /^spent/
    STATUS     = /^status/
    HELP       = /^help/

    # for internal testing purposes
    TRIGGER_ERROR = /^trigger error/
    TIME          = /^time/

    def call
      operation = parse_operation

      return Service::Result.new(value: 'no comprendo') if operation.nil?

      operation.new(user:, message: normalized_message).execute
    end

    private

    def parse_operation
      case normalized_message
      when SET_BUDGET then Chatbot::Operations::SetBudget
      when GET_BUDGET then Chatbot::Operations::GetBudget
      when SPENT      then Chatbot::Operations::Spent
      when STATUS     then Chatbot::Operations::Status
      when HELP       then Chatbot::Operations::Help
      when TIME       then time_operation
      when TRIGGER_ERROR then (raise 'error triggered')
      end
    end

    def user
      Users::FindOrCreate.call(phone: phone_number).value
    end

    def normalized_message
      binding.pry
      message.downcase.strip
    end

    def time_operation
      SimpleOperation.create do
        <<~TEXT
          Time.current: ${Time.current}
          DateTime.current: ${DateTime.current}
          Date.today: ${Date.today}
          Date.current: ${Date.current}
        TEXT
      end
    end

    module SimpleOperation
      def self.create(&block)
        Class.new do
          define_method(:initialize) { |*| }
          define_method(:execute) { yield }
        end
      end
    end

    attr_accessor :message, :phone_number
  end
end
