require_relative 'open_ai_wrapper/client'

module Lansky
  class AI
    attr_reader :client

    DEFAULT_CLIENT = OpenAIWrapper::Client

    def initialize(client: nil)
      @client = (client || DEFAULT_CLIENT).new
    end

    def parse_operation(input:)
      client.parse_operation(input: normalize_input(input))
    end

    private

    def normalize_input(input)
      input.downcase.gsub(/\s+/, ' ').strip
    end
  end
end
