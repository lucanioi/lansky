module Chatbot
  module Operations
    class Spending < Base
      params :period

      def run
        result = LedgerEntries::GenerateSpendingOverview.run(user:, period_range:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(overview)
        return no_spending_reply if overview.total_cents.zero?

        total = Helpers::MoneyHelper.format(overview.total_cents)

        "Total spent (#{period_title}):\n" \
        "*#{total}*\n\n" \
        "#{spending_details(overview)}"
      end

      def no_spending_reply
        "No spending found for #{period_title}"
      end

      def spending_details(overview)
        width_amount = overview.details.max_by(&:amount).amount.to_s.size + 1

        overview.details.map do |detail|
          formatted_amount = format_detail_amount(detail.amount, width_amount)
          "```#{formatted_amount}``` - #{detail.category}"
        end.join("\n")
      end

      def format_detail_amount(amount, width)
        Helpers::MoneyHelper.format(amount, trunc_cents: false, symbol: false)
                            .rjust(width)
      end

      def period_range
        @period_range ||=
          Helpers::DateTimeHelper.parse_to_period(period, include_current: true, direction: :backward)
      end

      def period_title
        capitalize_first_letter(Helpers::DateTimeHelper.format_period(period_range))
      end

      def capitalize_first_letter(string)
        string[0].upcase + string[1..]
      end
    end
  end
end
