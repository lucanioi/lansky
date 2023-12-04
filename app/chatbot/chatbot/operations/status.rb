module Chatbot
  module Operations
    class Status < BaseOperation
      # Currently, it uses current month's budget. It's a bit confusing,
      # since Budgets::CalculateStatus supports any budget period, and
      # the budget is derived based on current month. For now the
      # #period_name method assumes current month, but it could be
      # changed to use the period_start and period_end attributes of
      # the budget eventually.

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

        "You are over budget by *#{amount_over}* for #{period_name}."
      end

      def reply_for_under_budget(status)
        amount_left_today = format_money(status.amount_left_today)
        amount_left_period = format_money(status.amount_left_for_period)
        amount_per_day = format_money(status.amount_left_per_day)

        "You have *#{amount_left_today}* left to spend today.\n\n" \
        "You have *#{amount_left_period}* left for #{period_name}.\n\n" \
        "You're at *#{amount_per_day}* per day for the rest of the month."
      end

      def format_money(amount)
        ::Chatbot::MoneyHelper.format_euros_with_cents(amount)
      end

      def period_name
        budget.period_start.strftime('%B')
      end

      def budget
        @budget ||= user.budgets
                        .where('period_start <= ? AND period_end >= ?', Date.today, Date.today)
                        .first
      end
    end
  end
end
