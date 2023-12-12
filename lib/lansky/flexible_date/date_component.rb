module Lansky
  class FlexibleDate
    class DateComponent
      DEICTIC_OPTIONS = %w[this next prev].freeze

      def initialize(string,
        direction: :current,
        parent_present: false)
        @string = string

        @parent_present = parent_present
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
        return false unless string

        DEICTIC_OPTIONS.include?(string.delete_suffix(component_type).strip)
      end

      def named?
        raise NotImplementedError
      end

      private

      attr_reader :string, :direction

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

      def parent_present?
        @parent_present
      end

      def set_direction(direction)
        case string
        when /next / then :forward
        when /prev / then :backward
        else parent_present? ? :current : direction
        end
      end

      def include_current?
        !string.match?(/next |prev /)
      end

      def component_type
        self.class.name.demodulize.downcase
      end
    end
  end
end
