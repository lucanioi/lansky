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
      end

      params :user
    end
  end
end
