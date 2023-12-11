module Chatbot
  class Route
    attr_reader :operation, :params

    def initialize(operation:, params:)
      @operation = operation
      @params    = params
    end
  end
end
