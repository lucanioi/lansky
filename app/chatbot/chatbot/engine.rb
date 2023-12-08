module Chatbot
  class Engine
    include Runnable

    def run
      result = Webhooks::ProcessMessage.run(message:, user:)

    end

    private

    def router(_user)
      case mode
      when :classic then Chatbot::Engines::Classic::Router
      # when :ai then Chatbot::Engines::AI::Router
      end
    end

    def mode
      :classic
    end

    attr_accessor :message, :user
  end
end
