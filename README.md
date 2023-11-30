# Lansky

Helps track monthly spending

## Current Usage

Currently the Twilio sandbox is being used. To use the sandbox, you must be a verified number. To verify your number, send a text to +1 (415) 523-8886 on Whatsapp with the message "join wheat-biggest".

### Supported Operations

- `set budget <month> <amount>`: Sets the budget for the given month to the given amount
- `get budget <month>`: Gets the budget for the given month. `budget` is an alias for `get budget`
- `spent <amount> <category>`: Registers the given amount as spending to the given category
- `status`: Returns the budget status for the current period (month)

`month` could be substituted by `this month` or `next month` to refer to the current or next month respectively.
