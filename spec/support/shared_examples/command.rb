RSpec.shared_examples 'command tester' do |test_case|
  let(:message) { test_case[:input] }

  it 'returns the correct response' do
    if test_case[:error]
      expect { result }.to raise_error(test_case[:error])
    else
      expect(result).to eq(test_case[:output])
    end
  end
end

RSpec.shared_examples 'command' do |test_cases|
  describe 'execute' do
    let(:result) { described_class.new(message).execute }

    test_cases.each do |name, test_case|
      context name do
        it_behaves_like 'command tester', test_case
      end
    end
  end
end
