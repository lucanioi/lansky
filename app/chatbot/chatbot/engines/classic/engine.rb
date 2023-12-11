module Chatbot
  module Engines
    module Classic
      class Engine
        include Runnable

        def run
          route = router.run(message:).value!
          route.operation.run(user:, params: route.params).value!
        end

        private

        def router
          Engines::Classic::Router
        end

        attr_accessor :user, :message
      end
    end
  end
end
