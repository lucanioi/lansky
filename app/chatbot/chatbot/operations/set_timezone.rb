module Chatbot
  module Operations
    class SetTimezone < Base
      params :timezone_name

      def run
        return 'you need to specify a timezone' unless timezone_name.present?
        return "invalid timezone: #{timezone_name}" unless timezone

        result = Users::Update.run(user:, params: update_params)

        return reply if result.success?

        raise result.error
      end

      private

      def reply
        Time.use_zone(timezone) do
          "Timezone set to #{timezone.name} #{DateTime.current.formatted_offset}"
        end
      end

      def update_params
        {
          timezone: timezone.name
        }
      end

      def timezone
        @timezone ||=
          ActiveSupport::TimeZone.new(timezone_name.capitalize) ||
          ActiveSupport::TimeZone.new(timezone_name.upcase) ||
          ActiveSupport::TimeZone.new(timezone_name)
      end

      def validate_params!
        return if timezone_name.is_a?(String)

        raise InvalidParameter, "Invalid timezone: #{timezone_name.inspect}"
      end
    end
  end
end
