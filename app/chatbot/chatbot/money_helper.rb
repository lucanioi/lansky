module Chatbot
  module MoneyHelper
    MONEY_MATCHER = /^(€|$)?\d{1,3}(?:,?\d{3})*(?:\.\d{1,2})?$/
    DEFAULT_CURRENCY = :eur
    CURRENCY_SYMBOLS = {
      eur: '€'
    }.freeze

    module_function

    def format_euros(amount_in_cents, currency: :eur)
      euros  = amount_in_cents / 100
      amount = euros.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      "#{currency_symbol(currency)}#{amount}"
    end

    def format_euros_with_cents(amount_in_cents, currency: :eur)
      euros  = amount_in_cents / 100
      cents  = amount_in_cents % 100
      amount = euros.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      currency_symbol = currency_symbol(currency)

      cents > 0 ? "#{currency_symbol}#{amount}.#{pad(cents)}" : "#{currency_symbol}#{amount}"
    end

    def parse_to_cents(amount_string, currency: :eur)
      currency_symbol = currency_symbol(currency)
      normalized_amount = amount_string.gsub(currency_symbol, '').gsub(',', '')

      BigDecimal(normalized_amount) * 100
    end

    def parse_amount(string)
      m = string.match(MONEY_MATCHER)

      return unless m

      parse_to_cents(m[0])
    end

    def pad(amount)
      amount.to_s.rjust(2, '0')
    end

    def currency_symbol(currency_key)
      CURRENCY_SYMBOLS[currency_key] || CURRENCY_SYMBOLS[DEFAULT_CURRENCY]
    end
  end
end
