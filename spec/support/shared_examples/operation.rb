RSpec.shared_examples 'operation' do |test_cases|
  describe 'execute' do
    # Since `user` is made available in the scope of this shared example, we can
    # use it in the spec files that use this shared example.
    let(:user) { create :user }
    let(:result) { run_operation(user:, message:).value! }

    test_cases.each do |name, test_case|
      context name do
        let(:message) { test_case[:input] }

        it 'returns the correct response' do
          # Setup should be specified as a string that can be evaluated.
          # This is because using a proc would cause the setup to be evaluated
          # in the scope at the time of the test_case definition, which is
          # outside the scope of the example.
          if test_case[:setup]
            eval(test_case[:setup])
          end

          if test_case[:error]
            expect { result }.to raise_error(test_case[:error])
          else
            expect(result).to eq(test_case[:output])
          end
        end
      end
    end
  end
end
