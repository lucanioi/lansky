require 'rails_helper'

RSpec.describe Chatbot::Operations::GetCurrency do
  before do
    @current_currency = Money.default_currency
    Money.default_currency = :USD
  end

  after do
    Money.default_currency = @current_currency
  end

  it_behaves_like 'operation', {
    'returns default' => {
      input: 'get currency',
      output: 'Currency: USD',
    },
    'returns user currency' => {
      input: 'get currency',
      setup: 'update_user_currency "EUR"',
      output: 'Currency: EUR',
    },
  }

  def update_user_currency(currency)
    user.update!(currency: currency)
  end
end
