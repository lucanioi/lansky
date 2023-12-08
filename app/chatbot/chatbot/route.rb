module Chatbot
  class Route
    attr_reader :user, :operation, :params

    def initialize(user:, operation:, params:)
      @user      = user
      @operation = operation
      @params    = params
    end
  end
end
