require_relative 'openai_wrapper/client'

module Lansky
  class AI
    attr_reader :client
    delegate :function_call, to: :client

    DEFAULT_CLIENT = OpenAIWrapper::Client

    def initialize(input)
      @client = DEFAULT_CLIENT.new(input)
    end
  end
end
