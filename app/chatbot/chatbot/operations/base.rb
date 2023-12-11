module Chatbot
  module Operations
    class Base
      include Runnable
      prepend ValidateParams

      attr_accessor :user, :params

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

      def initialize(user:, params: {})
        validate_registered_params!(params)

        @user = user
        @params = params

        define_param_methods
      end

      def key
        self.class.key
      end

      private

      attr_reader :params

      def validate_registered_params!(params)
        return if params.nil? || params.empty?

        params.each_key do |param_name|
          next if self.class.params.include?(param_name)

          raise Operations::InvalidParameter, "Invalid param: #{param_name}"
        end
      end

      def define_param_methods
        self.class.params.each do |param_name|
          define_singleton_method(param_name.to_sym) do
            params[param_name.to_sym]
          end
        end
      end
    end
  end
end
