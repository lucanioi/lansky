module Chatbot
  class Engine
    include Runnable

    def run
      use_user_environment do
        result = router.run(user:, message:)
        return handle_error(result.error) if result.failure?
        route = result.value

        result = route.operation.run(user:, **route.params)
        return handle_error(result.error) if result.failure?
        result.value
      end
    end

    private

    def router
      case mode
      when :classic, nil then Engines::Classic::Router
      when :ai then Engines::AI::Router
      else
        raise "Unknown mode: #{mode}"
      end
    end

    def mode
      ENV['CHATBOT_MODE'].to_sym
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

    def handle_error(error)
      ErrorHandler.handle_error(error)
    end

    attr_accessor :user, :message, :mode
  end
end
