module Chatbot
  module Operations
    class Spending < BaseOperation
      params :period

      def execute
        result = Spendings::GenerateOverview.call(
          user:,
          period_start: period_range.begin,
          period_end: period_range.end
        )

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(overview)
        total = Chatbot::MoneyHelper.format(overview.total_in_cents)

        "Total spent (#{period.capitalize}):\n" \
        "*#{total}*\n\n" \
        "#{spending_details(overview)}"
      end

      def spending_details(overview)
        max_length = overview.details.max_by(&:amount).amount.to_s.size + 1 # +1 for the dot

        overview.details.map do |detail|
          amount = Chatbot::MoneyHelper.format(
            detail.amount,
            currency: nil,
            collapse_cents: false
          ).rjust(max_length)

          "#{amount} - #{detail.category}"
        end.join("\n")
      end

      def period_range
        @period_range ||=
          DateTimeHelper.parse_period(period, include_current: true)
      end
    end
  end
end
