module Chatbot
  module Engines
    module Classic
      module Parsers
        class Base
          def initialize(message)
            @message = message
          end

          def to_h
            raise NotImplementedError
          end

          private

          attr_reader :message
        end
      end
    end
  end
end
