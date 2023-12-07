module Chatbot
  module Operations
    class GetTimezone < BaseOperation
      def execute
        "Timezone: #{Time.zone.name} #{DateTime.current.formatted_offset}"
      end
    end
  end
end
