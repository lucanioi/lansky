module Chatbot
  module Operations
    class Status < BaseOperation
      def execute
        return 'No budget set for current period.' unless budget

        result = Budgets::CalculateStatus.call(user:, budget:)

        return reply(result.value) if result.success?

        raise result.error
      end

      private

      def reply(status)
        amount_left = status.amount_left_for_period

        return reply_for_under_budget(status) if amount_left.positive?

        reply_for_over_budget(status)
      end

      def reply_for_over_budget(status)
        amount_over = format_money(status.amount_left_for_period.abs)

        "You are over budget by *#{amount_over}* for #{period_title}."
      end

      def reply_for_under_budget(status)
        amount_left_period = format_money(status.amount_left_for_period)
        amount_per_day = format_money(status.daily_limit)

        "#{current_day_status(status)}\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Current daily limit is *#{amount_per_day}*."
      end

      def current_day_status(status)
        amount_left_today = format_money(status.amount_left_today)
        amount_spent_today = format_money(status.amount_spent_today)

        spent_today_text = status.amount_spent_today.positive? ?
          "You've already spent *#{amount_spent_today}*." :
          "You haven't spent anything yet."

        "You have *#{amount_left_today}* left for the day. #{spent_today_text}"
      end

      def format_money(amount)
        ::Chatbot::MoneyHelper.format(amount)
      end

      def period_title
        DateTimeHelper.format_period(budget.period_start..budget.period_end)
      end

      def budget
        @budget ||= user.budgets
                        .where('period_start <= ? AND period_end >= ?', Date.today, Date.today)
                        .first
      end
    end
  end
end
