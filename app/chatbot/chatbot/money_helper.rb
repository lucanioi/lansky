module Chatbot
  module MoneyHelper
    MONEY_MATCHER = /^(€|$)?\d{1,3}(?:,?\d{3})*(?:\.\d{1,2})?$/
    DEFAULT_CURRENCY = :EUR
    CURRENCY_SYMBOLS = {
      EUR: '€'
    }.freeze

    module_function

    def format(amount_cents, currency: :EUR, collapse_cents: true)
      whole  = amount_cents / 100
      cents  = amount_cents % 100
      amount = whole.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      currency_symbol = currency_symbol(currency)

      return "#{currency_symbol}#{amount}" if collapse_cents && cents.zero?

      "#{currency_symbol}#{amount}.#{pad(cents)}"
    end

    def parse_to_cents(amount_string, currency: :EUR)
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
      return if currency_key.nil?

      CURRENCY_SYMBOLS[currency_key] || CURRENCY_SYMBOLS[DEFAULT_CURRENCY]
    end
  end
end
