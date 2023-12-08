module Chatbot
  module Operations
    class BaseOperation
      include Runnable

      class << self
        alias_method :params, :attr_accessor
      end

      params :user
    end
  end
end
