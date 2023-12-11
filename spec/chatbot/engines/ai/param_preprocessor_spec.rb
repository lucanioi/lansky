require 'rails_helper'

RSpec.describe Chatbot::Engines::AI::ParamPreprocessor do
  let(:result) { described_class.run(params:, operation:) }

  test_cases = {
    'empty' => {
      input: {
        operation: :set_budget,
        params: {}
      },
      output: {},
    },
    'no dates' => {
      input: {
        operation: :set_budget,
        params: { foo: 'bar' }
      },
      output: { foo: 'bar' },
    },
    'day' => {
      input: {
        operation: :set_budget,
        params: { day: 'today', foo: 'bar' }
      },
      output: { flex_date: Lansky::FlexibleDate.new(day: 'today'), foo: 'bar' },
    },
    'a non-flex date operation' => {
      input: {
        operation: :something_else,
        params: { day: 'today', foo: 'bar' }
      },
      output: { day: 'today', foo: 'bar' },
    },
    'full date' => {
      input: {
        operation: :set_budget,
        params: { day: 'tuesday', week: 'this week', month: 'oct', year: '2024' }
      },
      output: {
        flex_date: Lansky::FlexibleDate.new(
          day: 'tuesday', week: 'this week', month: 'oct', year: '2024'
        )
      },
    },
  }

  test_cases.each do |name, test_case|
    context name do
      let(:params) { test_case[:input][:params] }
      let(:operation) { test_case[:input][:operation] }

      it 'returns the expected result' do
        expect(result.value!).to eq(test_case[:output])
      end
    end
  end
end
