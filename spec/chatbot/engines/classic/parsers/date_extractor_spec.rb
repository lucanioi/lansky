require 'rails_helper'

RSpec.describe Chatbot::Engines::Classic::Parsers::DateExtractor do
  test_cases = {
    'today'     => { day: 'today' },
    'tomorrow'  => { day: 'tomorrow' },
    'yesterday' => { day: 'yesterday' },
    'monday'    => { day: 'mon' },
    'october'   => { month: 'oct' },
    '2024'      => { year: '2024' },

    'this week'    => { week: 'this week' },
    'oct 2024'     => { month: 'oct', year: '2024' },
    'this year'    => { year: 'this year' },
    'last october' => { month: 'prev oct' },
    'next friday'  => { day: 'next fri' },
    'last month'   => { month: 'prev month' },

    'last october 3'    => { day: '3', month: 'prev oct' },
    'last week tuesday' => { day: 'tue', week: 'prev week' },
    '23 october 2024'   => { day: '23', month: 'oct', year: '2024' },
  }

  test_cases.each do |input, expected|
    it "parses #{input} to #{expected}" do
      result = described_class.run(string: input)
      expect(result.value!).to eq(expected)
    end
  end
end
