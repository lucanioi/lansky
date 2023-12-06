module Chatbot
  module MoneyHelper
    module_function

    def format(amount_cents, currency: nil, trunc_cents: true, symbol: true)
      money = Money.new(amount_cents, currency)
      cents = money.cents % 100

      trunc_cents && cents.zero? ?
        money.format(no_cents: true, symbol: symbol) :
        money.format(symbol: symbol)
    end

    def parse_amount(string, currency: nil)
      string = string.gsub(/(?<=\d)(,|\.)(?=\d{3}\b)/, '') # remove thousands separator

      Monetize.parse(string.upcase, currency)&.fractional
    end
  end
end
