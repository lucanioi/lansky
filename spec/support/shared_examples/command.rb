RSpec.shared_examples 'operation tester' do |test_case|
  let(:message) { test_case[:input] }

  it 'returns the correct response' do
    if test_case[:error]
      expect { result }.to raise_error(test_case[:error])
    else
      expect(result).to eq(test_case[:output])
    end
  end
end

RSpec.shared_examples 'operation' do |test_cases|
  describe 'execute' do
    let(:user) { create :user }
    let(:result) { described_class.new(user:, message:).execute }

    test_cases.each do |name, test_case|
      context name do
        it_behaves_like 'operation tester', test_case
      end
    end
  end
end
