require 'rails_helper'

RSpec.describe Chatbot::Operations::GetTimezone do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12))
    @original_timezone = Time.zone
  end

  after do
    Time.zone = @original_timezone
    Timecop.return
  end

  it_behaves_like 'operation', {
    'default is UTC' => {
      input: 'get timezone',
      output: 'Timezone: UTC +00:00',
    },
    'returns user timezone' => {
      input: 'get timezone',
      setup: 'set_timezone "Madrid"',
      output: 'Timezone: Madrid +02:00', # summer time
    },
  }

  def set_timezone(timezone)
    user.update!(timezone: timezone)
  end
end
