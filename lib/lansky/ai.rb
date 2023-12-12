require_relative 'open_ai_wrapper/client'

module Lansky
  class AI
    attr_reader :client

    DEFAULT_CLIENT = OpenAIWrapper::Client

    def initialize(client: nil, prompts: {})
      @client = (client || DEFAULT_CLIENT).new(prompts:)
    end

    def parse_operation(input:)
      client.parse_operation(input:)
    end

    def generate_response(input:)
      client.generate_response(input:)
    end
  end
end
