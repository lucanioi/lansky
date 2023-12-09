module Chatbot
  module Parsers
    module Date
      class DateComponent
        attr_reader :string, :direction, :parent_present

        def initialize(string,
                       direction: :current,
                       include_current: true,
                       parent_present: false)
          @string = string
          @direction = direction
          @include_current = include_current
          @parent_present = parent_present
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

        private
      end
    end
  end
end
