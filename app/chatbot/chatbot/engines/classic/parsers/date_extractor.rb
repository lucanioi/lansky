module Chatbot
  module Engines
    module Classic
      module Parsers
        class DateExtractor
          include Runnable

          InvalidPeriod = Class.new(Lansky::DisplayableError)

          DAYS_OF_WEEK = {
            'monday'    => 'mon',
            'tuesday'   => 'tue',
            'wednesday' => 'wed',
            'thursday'  => 'thu',
            'friday'    => 'fri',
            'saturday'  => 'sat',
            'sunday'    => 'sun'
          }.freeze

          MONTHS_OF_YEAR = {
            'january'   => 'jan',
            'february'  => 'feb',
            'march'     => 'mar',
            'april'     => 'apr',
            'may'       => 'may',
            'june'      => 'jun',
            'july'      => 'jul',
            'august'    => 'aug',
            'september' => 'sep',
            'october'   => 'oct',
            'november'  => 'nov',
            'december'  => 'dec'
          }.freeze

          DEICTIC_PREFIXES = ['this ', 'next ', 'prev '].freeze
          DEICTIC_DAYS = %w[today tomorrow yesterday].freeze
          NUMERIC_DAYS = /\b\d{1,2}\b/.freeze

          def run
            raise(InvalidPeriod, 'No date values detected') if attrs_absent?

            { year:, month:, week:, day: }
          end

          private

          def day
            valid_numeric_day || valid_named_day
          end

          def week
          end

          def month
            valid_named_month
          end

          def year
          end

          def normalized_string
            @normalized_string ||= begin
              str = string.downcase.strip.gsub(/last/, 'prev')
              str = DAYS_OF_WEEK.reduce(str) { |acc, (day, abbr)| acc.gsub(/#{day}/, abbr) }
              MONTHS_OF_YEAR.reduce(str) { |acc, (month, abbr)| acc.gsub(/#{month}/, abbr) }
            end
          end

          def valid_named_day
            str = normalized_string.gsub(/month/, '') # since 'month' matches 'mon', remove it

            [
              DAYS_OF_WEEK.values,
              DEICTIC_DAYS,
              DEICTIC_PREFIXES.product(DAYS_OF_WEEK.values).map(&:join),
            ].flatten.find { |day| str.include?(day) }
          end

          def valid_numeric_day
            m = string.match(NUMERIC_DAYS)
            m[0] if m
          end

          def valid_named_month
            [
              MONTHS_OF_YEAR.values,
              DEICTIC_PREFIXES.product(MONTHS_OF_YEAR.values).map(&:join),
              'this month', 'next month', 'prev month',
            ].flatten.find { |month| normalized_string.include?(month) }
          end

          def attrs_absent?
            year.nil? && month.nil? && week.nil? && day.nil?
          end

          attr_accessor :string
        end
      end
    end
  end
end
