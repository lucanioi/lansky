module Chatbot
  module Engines
    module AI
      class Engine
        include Runnable

        def run
          with_retry(1) { run_engine }
        end

        private

        def run_engine
          route = router.run(message: message_with_metadata).value!

          processed_params = process_params(route)

          route.operation.run(user:, params: processed_params).value!
        end

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

        def message_with_metadata
          <<~MESSAGE
            #{message}
            <METADATA>
              current_date: #{DateTime.current.to_date},
              current_currency: #{Money.default_currency},
              current_timezone: #{Time.zone.name}
            </METADATA>
          MESSAGE
        end

        def with_retry(retries)
          yield
        rescue StandardError => e
          raise e if retries.zero?

          if verbose?
            puts "Retrying AI engine (#{retries} #{'retry'.pluralize(retries)} left)..."
          end

          with_retry(retries - 1) { yield }
        end

        def verbose?
          ENV['VERBOSE'] == 'true' && !Rails.env.production?
        end

        attr_accessor :user, :message
      end
    end
  end
end
