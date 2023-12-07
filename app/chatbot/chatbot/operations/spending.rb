module Chatbot
  module Operations
    class Spending < BaseOperation
      params :period

      def execute
        result = LedgerEntries::GenerateSpendingOverview.call(user:, period_range:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(overview)
        return no_spending_reply if overview.total_cents.zero?

        total = Chatbot::MoneyHelper.format(overview.total_cents)

        "Total spent (#{period_title}):\n" \
        "*#{total}*\n\n" \
        "#{spending_details(overview)}"
      end

      def no_spending_reply
        "No spendings found for #{period_title}"
      end

      def spending_details(overview)
        amount_width = overview.details.max_by(&:amount).amount.to_s.size + 1

        overview.details.map do |detail|
          formatted_amount = format_detail_amount(detail.amount, amount_width)
          "```#{formatted_amount}``` - #{detail.category}"
        end.join("\n")
      end

      def format_detail_amount(amount, width)
        Chatbot::MoneyHelper.format(amount, trunc_cents: false, symbol: false)
                            .rjust(width)
      end

      def period_range
        @period_range ||=
          DateTimeHelper.parse_period(period, include_current: true, direction: :backward)
      end

      def period_title
        capitalize_first_letter(DateTimeHelper.format_period(period_range))
      end

      def capitalize_first_letter(string)
        string[0].upcase + string[1..]
      end
    end
  end
end
