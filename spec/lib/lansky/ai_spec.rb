require 'rails_helper'

RSpec.describe Lansky::AI do
  subject { described_class.new(client:, prompts:) }

  let(:response) { nil }
  let(:prompts) { { operations: [] } }
  let(:client) { Lansky::OpenAIWrapper::Client }

  describe '#parse_operation', :vcr do
    let(:result) { subject.parse_operation(input:) }

    let(:input) { 'Hello, my name is' }

    it 'returns a string' do
      expect(result).to be_nil
    end
  end
end
