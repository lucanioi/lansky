module Chatbot
  module Operations
    class Spending < Base
      params :flex_date

      def run
        result = LedgerEntries::GenerateSpendingOverview.run(user:, period:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(overview)
        return no_spending_reply if overview.spending_details.empty?

        total = Helpers::MoneyHelper.format(overview.total_cents)

        "Total spent (#{period_title}):\n" \
        "*#{total}*\n\n" \
        "#{spending_details(overview)}" \
        "#{recovery_details(overview)}"
      end

      def no_spending_reply
        "No spending found for #{period_title}"
      end

      def spending_details(overview)
        width_amount = overview.spending_details.max_by(&:amount).amount.to_s.size + 1

        overview.spending_details.map do |detail|
          formatted_amount = format_detail_amount(detail.amount, width_amount)
          "```#{formatted_amount}``` - #{detail.category}"
        end.join("\n")
      end

      def recovery_details(overview)
        return if overview.recovery_details.empty?

        width_amount = overview.recovery_details.max_by(&:amount).amount.to_s.size + 1

        details = overview.recovery_details.map do |detail|
          formatted_amount = format_detail_amount(-detail.amount, width_amount)
          "```#{formatted_amount}``` - #{detail.category} (recovered)"
        end.join("\n")

        "\n\n#{details}"
      end

      def format_detail_amount(amount, width)
        Helpers::MoneyHelper.format(amount, trunc_cents: false, symbol: false)
                            .rjust(width)
      end

      def period_title
        capitalize_first_letter(period.format)
      end

      def capitalize_first_letter(string)
        string[0].upcase + string[1..]
      end

      def period
        flex_date&.to_period(direction: :backward)
      end
    end
  end
end
