module Chatbot
  module Engines
    module AI
      class Engine
        include Runnable

        def run
          route = router.run(message:).value!
          route.operation.run(user:, **route.params).value!
        end

        private

        def router
          Engines::AI::Router
        end

        attr_accessor :user, :message
      end
    end
  end
end
