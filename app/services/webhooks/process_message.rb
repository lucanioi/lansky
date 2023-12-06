module Webhooks
  class ProcessMessage
    include Service

    SET_BUDGET = /^set budget/
    GET_BUDGET = /^get budget|^budget /
    SPENT      = /^spent/
    STATUS     = /^status/
    HELP       = /^help/
    SPENDING   = /^spending/
    SET_TZ     = /^set timezone/

    # for internal testing purposes
    TRIGGER_ERROR = /^trigger error/
    TIME          = /^time/

    def call
      use_user_environment { process_message }
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
      when SET_TZ     then Chatbot::Operations::SetTimezone
      when TIME       then time_operation
      when TRIGGER_ERROR then (raise 'error triggered')
      end
    end

    def normalized_message
      message.downcase.strip
    end

    def use_user_environment(&block)
      Time.use_zone(user.timezone) do
        original_currency = Money.default_currency
        Money.default_currency = user.currency || original_currency
        block.call
      ensure
        Money.default_currency = original_currency
      end
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
