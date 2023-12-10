require_relative 'open_ai_wrapper/client'

module Lansky
  class AI
    attr_reader :client

    DEFAULT_CLIENT = OpenAIWrapper::Client

    def initialize(client: nil)
      @client = (client || DEFAULT_CLIENT).new
    end

    def function_call(input:)
      client.function_call(input:)
    end
  end
end
