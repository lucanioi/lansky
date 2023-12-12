module Chatbot
  class Engine
    include Runnable

    DEFAULT_MODE = :classic

    def run
      use_user_environment do
        engine.run(user:, message:, config:).value!
      end
    rescue StandardError => error
      handle_error(error)
    end

    private

    def engine
      case mode.to_sym
      when :classic, nil then Engines::Classic::Engine
      when :ai then Engines::AI::Engine
      else
        raise "Unknown mode: #{mode}"
      end
    end

    def mode
      @mode || user.chatbot_mode || ENV['CHATBOT_MODE'] || DEFAULT_MODE
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

    attr_accessor :user, :message, :config
    attr_writer :mode
  end
end
