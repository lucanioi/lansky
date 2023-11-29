module Chatbot
  module Params
    class GetBudget < BaseParams
      VALID_MONTHS = Date::MONTHNAMES.compact + ['this month', 'next month']

      def month
        @month ||= extract_month
      end

      private

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
