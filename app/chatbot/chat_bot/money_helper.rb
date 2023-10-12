module ChatBot
  module MoneyHelper
    MONEY_MATCHER = /\d{1,3}(?:,?\d{3})*(?:\.\d{2})?$/

    module_function

    def format_euros(amount_in_cents)
      euros = amount_in_cents / 100
      amount = euros.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      "€#{amount}"
    end

    def parse_to_cents(money_string)
      money_string.gsub('€', '').gsub(',', '').to_f * 100
    end

    def extract_amount(string)
      m = string.match(MONEY_MATCHER)

      return unless m

      parse_to_cents(m[0])
    end
  end
end
