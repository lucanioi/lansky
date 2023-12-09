module Chatbot
  module Parsers
    module Date
      class Parser
        InvalidPeriod = Class.new(Lansky::DisplayableError)

        DAYS_OF_WEEK      = %w[sunday monday tuesday wednesday thursday
                              friday saturday]
        DAYS_OF_WEEK_ABBR = %w[sun mon tue wed thu fri sat]

        MONTHS_OF_YEAR      = %w[january february march april may june july august
                                september october november december]
        MONTHS_OF_YEAR_ABBR = %w[jan feb mar apr may jun jul aug sep oct nov dec]

        NUMERIC_YEARS  = ('1900'..'2100').to_a
        NUMERIC_DAYS   = ('1'..'31').to_a
        NUMERIC_WEEKS  = ('1'..'4').to_a
        NUMERIC_MONTHS = ('1'..'12').to_a

        class << self
          def parse_period(day: nil, week: nil, month: nil, year: nil, **options)
            new(day:, week:, month:, year:, **options).parse_period
          end

          private :new
        end

        def initialize(day:, week:, month:, year:, **options)
          @day = Day.new(day, **options)
          @week = week
          @month = Month.new(month, **options)
          @year = year

          @include_current  = options[:include_current] || false
          @direction        = options[:direction] || :forward
          @skip_validations = options[:skip_validations] || false
        end

        def parse_period
          Models::Period.new(period_start:, period_end:)
        end

        def period_start
          datetime = DateTime.current

          month.resolve(datetime).then { |dt| day.resolve(dt) }
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
