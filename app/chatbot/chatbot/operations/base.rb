module Chatbot
  module Operations
    class Base
      include Runnable

      class << self
        def params(*param_names)
          return (@params ||= []) if param_names.empty?

          if @params.nil?
            attr_accessor *param_names

            return (@params = param_names)
          end

          raise "Params already defined: #{@params}"
        end

        def key
          name.demodulize.underscore.to_sym
        end
      end

      params :user

      def key
        self.class.key
      end
    end
  end
end
