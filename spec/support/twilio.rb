module SpecHelpers
  module Twilio
    def format_twiml(body)
      <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <Response>
        <Message>#{body}</Message>
        </Response>
      XML
    end
  end
end
