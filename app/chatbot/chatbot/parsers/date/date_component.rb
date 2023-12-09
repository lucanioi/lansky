module Chatbot
  module Parsers
    module Date
      class DateComponent
        DEICTIC_OPTIONS = %w[this next prev].freeze

        def initialize(string,
          direction: :current,
          include_current: true,
          parent_present: false)
          @string = string

          @parent_present = parent_present
          @include_current = set_include_current(include_current)
          @direction = set_direction(direction)

          validate!
        end

        def resolve(datetime)
          raise NotImplementedError
        end

        def blank?
          string.blank?
        end

        def valid_numeric?
          raise NotImplementedError
        end

        def deictic?
          DEICTIC_OPTIONS.include?(string)
        end

        def named?
          raise NotImplementedError
        end

        private

        attr_reader :string, :include_current, :direction, :parent_present

        def direction
          case string
          when /next / then :forward
          when /prev / then :backward
          else @direction
          end
        end

        def validate!
          raise NotImplementedError
        end

        def set_direction(direction)
          case string
          when /next / then :forward
          when /prev / then :backward
          else parent_present ? :current : direction
          end
        end

        def set_include_current(include_current)
          return include_current if blank?
          return false if string.match?(/next |prev /)

          parent_present ? true : include_current
        end
      end
    end
  end
end
