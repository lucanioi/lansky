require 'spec_helper'

RSpec.describe Lansky::AI do
  subject { described_class.new(client:) }

  let(:response) { nil }
  let(:client) { fake_client(response) }

  describe '#function_call' do
    let(:result) { subject.function_call(input:) }

    let(:input) { 'Hello, my name is' }

    it 'returns a string' do
      raise 'test error'
      expect(result).to be_nil
    end
  end

  def fake_client(response)
    Class.new { define_method(:function_call) { |*| response } }
  end
end
