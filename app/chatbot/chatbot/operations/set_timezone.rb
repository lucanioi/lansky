module Chatbot
  module Operations
    class SetTimezone < BaseOperation
      params :timezone

      def execute
        return "invalid timezone: #{timezone}" unless timezone_obj

        result = Users::Update.call(user:, params: update_params)

        return reply if result.success?

        raise result.error
      end

      private

      def reply
        "Timezone set to #{timezone_obj.name} #{timezone_obj.formatted_offset}"
      end

      def update_params
        {
          timezone: timezone_obj.name
        }
      end

      def timezone_obj
        @timezone_obj ||= ActiveSupport::TimeZone.new(timezone.capitalize)
      end
    end
  end
end