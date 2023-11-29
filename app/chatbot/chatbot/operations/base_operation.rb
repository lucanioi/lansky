# require_relative '../helpers/money_helper'

module Chatbot
  module Operations
    class BaseOperation
      attr_reader :user, :message

      def initialize(user:, message:)
        @user = user
        @message = message
      end

      class << self
        def params(*param_names)
          param_names.each do |param_name|
            delegate *param_names, to: :params
          end
        end
      end

      def params
        operation_name = self.class.name.demodulize

        @params ||= Chatbot::Params.const_get(operation_name).new(message)
      end
    end
  end
end
