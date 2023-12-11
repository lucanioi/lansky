module Chatbot
  module Engines
    module AI
      class ParamPreprocessor
        include Runnable

        def run
          convert_to_flex_date
        end

        private

        def flex_date(**params)
          Lansky::FlexibleDate.new(**params)
        end

        def convert_to_flex_date
          return params unless operation_accepts_flex_date?

          date_params = params.slice(:date)

          return params if date_params.empty?

          params.except(:date)
                .merge(flex_date: flex_date(**date_params[:date]))
        end

        def operation_accepts_flex_date?
          operation.params.include?(:flex_date)
        end

        attr_accessor :params, :operation
      end
    end
  end
end
