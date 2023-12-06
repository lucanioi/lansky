module Webhooks
  class ProcessMessage
    include Service

    SET_BUDGET = /^set budget/
    GET_BUDGET = /^get budget|^budget /
    SPENT      = /^spent/
    STATUS     = /^status/
    HELP       = /^help/
    SPENDING   = /^spending/

    # for internal testing purposes
    TRIGGER_ERROR = /^trigger error/
    TIME          = /^time/

    def call
      use_user_timezone { process_message }
    end

    private

    def process_message
      operation = parse_operation

      return Service::Result.new(value: 'no comprendo') if operation.nil?

      operation.new(user:, message: normalized_message).execute
    end

    def parse_operation
      case normalized_message
      when SET_BUDGET then Chatbot::Operations::SetBudget
      when GET_BUDGET then Chatbot::Operations::GetBudget
      when SPENT      then Chatbot::Operations::Spent
      when STATUS     then Chatbot::Operations::Status
      when HELP       then Chatbot::Operations::Help
      when SPENDING   then Chatbot::Operations::Spending
      when TIME       then time_operation
      when TRIGGER_ERROR then (raise 'error triggered')
      end
    end

    def normalized_message
      message.downcase.strip
    end

    def use_user_timezone(&block)
      Time.use_zone(user.timezone, &block)
    end

    def user
      @user ||= Users::FindOrCreate.call(phone:).value
    end

    #####################
    # SIMPLE OPERATIONS #
    #####################

    def time_operation
      SimpleOperation.create do
        <<~TEXT
          Time.current: #{Time.current}
          DateTime.current: #{DateTime.current}
          Date.today: #{Date.today}
          Date.current: #{Date.current}
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

    attr_accessor :message, :phone
  end
end
