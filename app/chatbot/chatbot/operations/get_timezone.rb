module Chatbot
  module Operations
    class GetTimezone < Base
      def run
        "Timezone: #{Time.zone.name} #{DateTime.current.formatted_offset}"
      end
    end
  end
end
