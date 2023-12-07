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

      def reply(status)
        return reply_period_over_budget(status)  if status.period_remaining_amount.negative?
        return reply_period_exact_budget(status) if status.period_remaining_amount.zero?
        return reply_today_over_budget(status)   if status.today_remaining_amount.negative?
        return reply_today_exact_budget(status)  if status.today_remaining_amount.zero?

        reply_under_budget(status)
      end

      def reply_today_over_budget(status)
        period_daily_limit   = format_money(status.period_daily_limit)
        amount_over             = format_money(status.today_remaining_amount.abs)
        period_remaining_amount = format_money(status.period_remaining_amount)

        "You are over budget by *#{amount_over}* today.\n\n" \
        "You have *#{period_remaining_amount}* left for #{period_title}.\n\n" \
        "Adjusted daily limit is *#{period_daily_limit}* for the rest of the period."
      end

      def reply_period_exact_budget(status)
        period_spent_amount     = format_money(budget.amount_cents)
        period_remaining_amount = format_money(status.period_remaining_amount)

        "You've spent the total budget of *#{period_spent_amount}*.\n\n" \
        "No remaining budget for #{period_title}. You can overwrite and increase " \
        "the budget by the `set budget` operation."
      end

      def reply_period_over_budget(status)
        amount_over = format_money(status.period_remaining_amount.abs)

        "You are over budget by *#{amount_over}* for #{period_title}."
      end

      def reply_today_exact_budget(status)
        today_limit       = format_money(status.today_limit)
        period_daily_limit   = format_money(status.period_daily_limit)
        period_remaining_amount = format_money(status.period_remaining_amount)

        "Today's spending is spot on the budget, exactly *#{today_limit}*.\n\n" \
        "You have *#{period_remaining_amount}* left for #{period_title}.\n\n" \
        "Daily limit remains at *#{period_daily_limit}* for the rest of the period."
      end

      def reply_under_budget(status)
        period_daily_limit   = format_money(status.period_daily_limit)
        period_remaining_amount = format_money(status.period_remaining_amount)

        "#{current_day_status(status)}\n\n" \
        "You have *#{period_remaining_amount}* left for #{period_title}" \
        "#{period_surplus_message(status)}.\n\n" \
        "Current daily limit is *#{period_daily_limit}*."
      end

      def current_day_status(status)
        today_recovered_amount = format_money(status.today_recovered_amount)
        today_remaining_amount = format_money(status.today_remaining_amount)
        today_spent_amount     = format_money(status.today_spent_amount)

        spent_today = status.today_spent_amount.positive?

        recovery_message = status.today_recovered_amount.positive? ?
          " #{spent_today ? 'and' : 'but'} recovered *#{today_recovered_amount}*" : ''

        spent_today_text = spent_today ?
          "You've spent *#{today_spent_amount}*#{recovery_message}." :
          "You haven't spent anything yet#{recovery_message}."

        "You have *#{today_remaining_amount}* left for the day. #{spent_today_text}"
      end

      def period_surplus_message(status)
        return '' unless status.period_surplus_amount.positive?

        surplus_amount = format_money(status.period_surplus_amount)

        " with an additional #{surplus_amount} surplus"
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
