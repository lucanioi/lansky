module Chatbot
  module Commands
    class Spent < BaseCommand
      attr_reader :message, :params
      delegate :amount_in_cents, :category_name, to: :params

      def initialize(message)
        @message = message
        @params = Chatbot::Parsers::Spent.new(message)
      end

      def execute
        result = Spending::Create.call(category:, amount_in_cents:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def category
        SpendingCategories::FindOrCreate.call(name: category_name)
      end
    end
  end
end
