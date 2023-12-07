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
        return reply_period_over_budget(status)    if status.amount_left_period.negative?
        return reply_period_spot_on_budget(status) if status.amount_left_period.zero?
        return reply_daily_over_budget(status)     if status.amount_left_today.negative?
        return reply_daily_spot_on_budget(status)  if status.amount_left_today.zero?

        reply_under_budget(status)
      end

      def reply_daily_over_budget(status)
        remaining_daily_limit = format_money(status.remaining_daily_limit)
        amount_over           = format_money(status.amount_left_today.abs)
        amount_left_period    = format_money(status.amount_left_period)

        "You are over budget by *#{amount_over}* today.\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Adjusted daily limit is *#{remaining_daily_limit}* for the rest of the period."
      end

      def reply_period_spot_on_budget(status)
        amount_spent_period = format_money(budget.amount_cents)
        amount_left_period  = format_money(status.amount_left_period)

        "You've spent the total budget of *#{amount_spent_period}*.\n\n" \
        "No remaining budget for #{period_title}. You can overwrite and increase " \
        "the budget by the `set budget` operation."
      end

      def reply_period_over_budget(status)
        amount_over = format_money(status.amount_left_period.abs)

        "You are over budget by *#{amount_over}* for #{period_title}."
      end

      def reply_daily_spot_on_budget(status)
        today_daily_limit     = format_money(status.today_daily_limit)
        remaining_daily_limit = format_money(status.remaining_daily_limit)
        amount_left_period    = format_money(status.amount_left_period)

        "Today's spending is spot on the budget, exactly *#{today_daily_limit}*.\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Daily limit remains at *#{remaining_daily_limit}* for the rest of the period."
      end

      def reply_under_budget(status)
        remaining_daily_limit = format_money(status.remaining_daily_limit)
        amount_left_period    = format_money(status.amount_left_period)

        "#{current_day_status(status)}\n\n" \
        "You have *#{amount_left_period}* left for #{period_title}.\n\n" \
        "Current daily limit is *#{remaining_daily_limit}*."
      end

      def current_day_status(status)
        amount_recovered_today = format_money(status.amount_recovered_today)
        amount_left_today      = format_money(status.amount_left_today)
        amount_spent_today     = format_money(status.amount_spent_today)

        spent_today = status.amount_spent_today.positive?

        recovery_message = status.amount_recovered_today.positive? ?
          " #{spent_today ? 'and' : 'but'} recovered *#{amount_recovered_today}*" : ''

        spent_today_text = spent_today ?
          "You've spent *#{amount_spent_today}*#{recovery_message}." :
          "You haven't spent anything yet#{recovery_message}."

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
                        .where('period_start <= ? AND period_end >= ?', Time.zone.today, Time.zone.today)
                        .last
      end
    end
  end
end
