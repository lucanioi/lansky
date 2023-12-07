## `Budgets::Stats`

This module contains value objects that are used to calculate statistics for a budget period. They must all expose the following API to the operation handler:

`today_spent_amount`
`today_recovered_amount`
`today_remaining_amount`
`today_limit`
`period_spent_amount`
`period_recovered_amount`
`period_remaining_amount`
`period_daily_limit`
`period_surplus_amount`

The classes inherit from `Budgets::Stats::Base` , which contain some of those fields already implemented. the inheriting classes must implement the rest of the fields.
