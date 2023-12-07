module Chatbot
  module Operations
    class Status < BaseOperation
      def execute
        return 'No budget set for current period.' unless budget

        result = Budgets::Stats::Calculate.call(user:, budget:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(stats)
        [
          today_summary(stats),
          period_summary(stats),
          daily_limit_summary(stats),
        ].reject(&:blank?).join("\n\n")
      end

      def today_summary(stats)
        return '' if period_over_budget?(stats) || period_exact_budget?(stats)

        [
          today_limit_message(stats),
          today_spending_message(stats),
          today_recovery_message(stats),
        ].reject(&:blank?).join(' ').delete_suffix('.') + '.'
      end

      def today_limit_message(stats)
        if today_over_budget?(stats)
          over_amount = format_money(stats.today_remaining_amount.abs)
          "You are over budget by *#{over_amount}* today."
        elsif today_exact_budget?(stats)
          today_limit = format_money(stats.today_limit)
          "Today's spending is spot on the budget, exactly *#{today_limit}*."
        else
          today_remaining_amount = format_money(stats.today_remaining_amount)
          "You have *#{today_remaining_amount}* left for the day."
        end
      end

      def today_spending_message(stats)
        today_spent_amount = format_money(stats.today_spent_amount)

        return '' if today_exact_budget?(stats)
        return "You haven't spent anything yet" if stats.today_spent_amount.zero?

        "You've spent *#{today_spent_amount}*"
      end

      def today_recovery_message(stats)
        return '' if stats.today_recovered_amount.zero?

        conjunction = stats.today_spent_amount.positive? ? 'and' : 'but'
        today_recovered_amount = format_money(stats.today_recovered_amount)

        "#{conjunction} recovered *#{today_recovered_amount}*"
      end

      def period_summary(stats)
        amount = stats.period_remaining_amount

        if period_over_budget?(stats)
          over_amount = format_money(amount.abs)
          "You are over budget by *#{over_amount}* for #{period_title}."
        elsif period_exact_budget?(stats)
          budget_amount = format_money(stats.budgeted_amount)
          "You've spent the total budget of *#{budget_amount}* for #{period_title}.\n\n" \
          "You can overwrite and increase the budget by the `set budget` operation."
        else
          period_remaining_amount = format_money(amount)
          "You have *#{period_remaining_amount}* left for #{period_title}" \
          "#{period_surplus_message(stats)}."
        end
      end

      def daily_limit_summary(stats)
        period_daily_limit = format_money(stats.period_daily_limit)

        if period_over_budget?(stats) || period_exact_budget?(stats)
          ''
        elsif today_over_budget?(stats)
          "Adjusted daily limit is *#{period_daily_limit}* for the rest of the period."
        else
          "Current daily limit is *#{period_daily_limit}*."
        end
      end

      def period_surplus_message(status)
        return '' unless status.period_surplus_amount.positive?

        surplus_amount = format_money(status.period_surplus_amount)

        " with an additional #{surplus_amount} surplus"
      end

      def today_over_budget?(stats)
        stats.today_remaining_amount.negative?
      end

      def today_exact_budget?(stats)
        stats.today_remaining_amount.zero?
      end

      def period_over_budget?(stats)
        stats.period_remaining_amount.negative?
      end

      def period_exact_budget?(stats)
        stats.period_remaining_amount.zero?
      end

      def period_surplus?(stats)
        stats.period_surplus_amount.positive?
      end

      def format_money(amount)
        ::Chatbot::MoneyHelper.format(amount)
      end

      def period_title
        DateTimeHelper.format_period(budget.period_start..budget.period_end)
      end

      def budget
        @budget ||= user.budgets
                        .where('period_start <= ? AND period_end >= ?', Time.zone.today, Time.zone.today)
                        .last
      end
    end
  end
end
