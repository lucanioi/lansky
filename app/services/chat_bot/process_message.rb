module ChatBot
  class ProcessMessage
    include Service

    SET_BUDGET = /set budget/

    def call
      result = process_message

      return result.value if result.success?

      raise result.error
    end

    private

    def process_message
      case body
      when SET_BUDGET then ChatBot::Commands::SetBudget.call(body: body)
      else
        Service::Result.new(value: 'no comprendo')
      end
    end

    attr_accessor :body
  end
end
