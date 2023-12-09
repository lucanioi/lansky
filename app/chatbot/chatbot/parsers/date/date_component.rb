module Chatbot
  module Parsers
    module Date
      class DateComponent
        attr_reader :string, :direction, :parent_present

        DEICTIC_OPTIONS = %w[this next prev].freeze

        def initialize(string,
                       direction: :current,
                       include_current: true,
                       parent_present: false)
          @string = string
          @direction = direction
          @include_current = include_current
          @parent_present = parent_present

          validate!
        end

        def include_current
          return true if parent_present

          @include_current
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

        def validate!
          raise NotImplementedError
        end
      end
    end
  end
end
