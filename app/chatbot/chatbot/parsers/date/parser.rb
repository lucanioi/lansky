module Chatbot
  module Parsers
    module Date
      class Parser
        class << self
          def parse_from_params(day: nil, week: nil, month: nil, year: nil, **options)
            new(day:, week:, month:, year:, **options).parse
          end

          private :new
        end

        def initialize(day:, week:, month:, year:, **options)
          @day   = Day.new   day,   parent_present: week.present?, **options
          @week  = Week.new  week,                                 **options
          @month = Month.new month, parent_present: year.present?, **options
          @year  = Year.new  year,                                 **options
        end

        def parse
          Period.new(period_start, period_end)
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

        attr_reader :day, :week, :month, :year
      end
    end
  end
end
