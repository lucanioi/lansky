module Chatbot
  module Operations
    module ValidateParams
      def run
        validate_params! if self.class.params.any?

        super
      end

      private

      def validate_params!
        raise NotImplementedError, 'Implement #validate_params! in your operation'
      end
    end
  end
end
