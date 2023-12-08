module Lansky
  class OpenAIClient
    attr_reader :client, :input

    def initialize(input)
      @input  = input
      @client = OpenAI::Client.new
    end

    def operation_call
    end
  end
end
