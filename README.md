# Lansky

Helps track monthly spending

## Current Usage

Currently the Twilio sandbox is being used. To use the sandbox, you must be a verified number. To verify your number, send a text to +1 (415) 523-8886 on Whatsapp with the message "join wheat-biggest".

### Supported Operations

- `set budget <month> <amount>`: Sets the budget for the given month to the given amount
- `get budget <month>`: Gets the budget for the given month. `budget` is an alias for `get budget`
- `spent <amount> <category>`: Registers the given amount as spending to the given category
- `status`: Returns the budget status for the current period (month)
- `spending <period>`: Returns the spending for the given period. `period` can be `today`, `yesterday`, `week`, `month`, `year`, or `all time`. It includes the total spent and the spending per category.

`month` could be substituted by `this month` or `next month` to refer to the current or next month respectively. Similarly, words like `today` and `yesterday` could also substitute for specific dates.

## Technical Details

### Monkypatching

The following classes are monkeypatched:

#### Date
The following aliases are added for `Date`'s instance methods:
`bod`: `beginning_of_day`
`eod`: `end_of_day`
`bow`: `beginning_of_week`
`eow`: `end_of_week`
`bom`: `beginning_of_month`
`eom`: `end_of_month`
`boy`: `beginning_of_year`
`eoy`: `end_of_year`

