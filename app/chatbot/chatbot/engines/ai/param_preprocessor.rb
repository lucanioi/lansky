module Chatbot
  module Engines
    module AI
      class ParamPreprocessor
        include Runnable

        COMMON_HALLUCINATIONS = {
          budget_cents: :amount_cents,
        }.freeze

        def run
          params
            .then(&method(:convert_to_flex_date))
            .then(&method(:convert_common_hallucinations))
        end

        private

        def flex_date(**attrs)
          Lansky::FlexibleDate.new(**attrs)
        end

        def convert_to_flex_date(_params)
          return _params unless operation_accepts_flex_date?

          date_params = _params.slice(:date)

          return _params if date_params.empty?

          _params.except(:date)
                 .merge(flex_date: flex_date(**date_params[:date]))
        end

        def convert_common_hallucinations(_params)
          _params.reduce({}) do |acc, (key, value)|
            k = COMMON_HALLUCINATIONS.fetch(key, key)
            acc.merge(k => value)
          end
        end

        def operation_accepts_flex_date?
          operation.params.include?(:flex_date)
        end

        attr_accessor :params, :operation
      end
    end
  end
end
