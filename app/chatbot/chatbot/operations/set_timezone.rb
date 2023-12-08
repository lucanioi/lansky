module Chatbot
  module Operations
    class SetTimezone < BaseOperation
      params :timezone_name

      def execute
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
    end
  end
end
