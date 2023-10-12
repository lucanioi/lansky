module Chatbot
  module Parsers
    class GetBudget
      attr_reader :month

      VALID_MONTHS = Date::MONTHNAMES.compact + ['this month', 'next month']

      def initialize(message)
        @message = message
        extract
      end

      private

      attr_reader :message

      def extract
        @month = extract_month
      end

      def argument
        message.delete_prefix('get ').delete_suffix('budget ')
      end

      def extract_month
        VALID_MONTHS.find do |month|
          argument.downcase.include?(month.downcase)
        end || (raise 'invalid month')
      end
    end
  end
end
