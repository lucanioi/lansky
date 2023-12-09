module Chatbot
  module Parsers
    module Date
      class Parser
        InvalidPeriod = Class.new(Lansky::DisplayableError)

        class << self
          def parse_period(day: nil, week: nil, month: nil, year: nil, **options)
            new(day:, week:, month:, year:, **options).parse_period
          end

          private :new
        end

        def initialize(day:, week:, month:, year:, **options)
          @day   = Day.new   day,   parent_present: week.present?, **options
          @week  = Week.new  week,                                 **options
          @month = Month.new month, parent_present: year.present?, **options
          @year  = Year.new  year,                                 **options

          @include_current  = options[:include_current] || false
          @direction        = options[:direction] || :forward
          @skip_validations = options[:skip_validations] || false
        end

        def parse_period
          Models::Period.new(period_start:, period_end:)
        end

        def period_start
          datetime = DateTime.current.bod

          datetime
            .then { |dt| year.resolve(dt) }
            .then { |dt| month.resolve(dt) }
            .then { |dt| week.resolve(dt) }
            .then { |dt| day.resolve(dt) }
        end

        def period_end
          case
          when day.present? then period_start + 1.day
          when week.present? then period_start + 1.week
          when month.present? then period_start + 1.month
          else
            period_start + 1.year
          end
        end

        private

        attr_reader :day, :week, :month, :year,
                    :include_current, :direction,
                    :result_date

        def skip_validations?
          @skip_validations
        end

        def invalid_period!(msg)
          raise InvalidPeriod, "Invalid period: #{msg}\n\n" \
                              "day: #{day.inspect}\n" \
                              "week: #{week.inspect}\n" \
                              "month: #{month.inspect}\n" \
                              "year: #{year.inspect}"
        end
      end
    end
  end
end
