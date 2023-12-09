module Chatbot
  module Parsers
    module Date
      class DateComponent
        attr_reader :string, :direction, :include_current

        def initialize(string, direction: :forward, include_current: false)
          @string = string
          @direction = direction
          @include_current = include_current
        end

        def resolve(datetime)
          raise NotImplementedError
        end

        private

        def blank?
          string.blank?
        end
      end
    end
  end
end
