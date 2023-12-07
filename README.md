# Lansky

Helps track monthly spending

## Current Usage

Currently the Twilio sandbox is being used. To use the sandbox, you must be a verified number. To verify your number, send a text to +1 (415) 523-8886 on Whatsapp with the message "join wheat-biggest".

### Supported Operations

- `set budget <period> <amount>`: Sets the budget for the given period to the given amount
- `get budget <period>`: Gets the budget for the given period. `budget` is an alias for `get budget`
- `spent <amount> <category>`: Registers the given amount as spending to the given category
- `status`: Returns the budget status for the current period
- `spending <period>`: Returns the spending for the given period. `period` can be `today`, `yesterday`, `week`, `month`, `year`, or `all time`. It includes the total spent and the spending per category.
- `set currency <currency>`: Sets the currency to the given currency.
- `set timezone <timezone>`: Sets the timezone to the given timezone. Timezone must be a valid timezone location like 'Madrid', 'Japan', or 'America/Los_Angeles'

`period` can accept names of months and days like `january`, `monday`, as well as deictic expressions like `this month`, `last week`, `next year`, `yesterday`, `today`, `tomorrow`, etc.

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

