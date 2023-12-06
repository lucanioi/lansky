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
        return reply_period_over_budget(status) if status.amount_left_period.negative?
        return reply_daily_over_budget(status) if status.amount_left_today.negative?

        reply_under_budget(status)
      end

      def reply_daily_over_budget(status)
        amount_over = format_money(status.amount_left_today.abs)
        amount_left_period = format_money(status.amount_left_period)
        adjusted_daily_limit = format_money(status.adjusted_daily_limit)

        "You are over budget by *#{amount_over}* today.\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Adjusted daily limit is *#{adjusted_daily_limit}* for the rest of the period."
      end

      def reply_period_over_budget(status)
        amount_over = format_money(status.amount_left_period.abs)

        "You are over budget by *#{amount_over}* for #{period_title}."
      end

      def reply_under_budget(status)
        amount_left_period = format_money(status.amount_left_period)
        current_daily_limit = format_money(status.current_daily_limit)

        "#{current_day_status(status)}\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Current daily limit is *#{current_daily_limit}*."
      end

      def current_day_status(status)
        amount_left_today = format_money(status.amount_left_today)
        amount_spent_today = format_money(status.amount_spent_today)

        spent_today_text = status.amount_spent_today.positive? ?
          "You've already spent *#{amount_spent_today}*." :
          "You haven't spent anything yet."

        "You have *#{amount_left_today}* left today. #{spent_today_text}"
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
                        .last
      end
    end
  end
end
