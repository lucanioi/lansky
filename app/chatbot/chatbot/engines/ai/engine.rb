module Chatbot
  module Engines
    module AI
      class Engine
        include Runnable

        def run
          route = router.run(message:).value!

          processed_params = process_params(route)

          route.operation.run(user:, params: processed_params).value!
        end

        private

        def process_params(route)
          return {} if route.params.empty?

          ParamPreprocessor.run(
            params: route.params,
            operation: route.operation,
          ).value!
        end

        def router
          Engines::AI::Router
        end

        attr_accessor :user, :message
      end
    end
  end
end
