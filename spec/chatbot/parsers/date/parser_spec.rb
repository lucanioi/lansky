require 'rails_helper'

RSpec.describe Chatbot::Parsers::Date::Parser do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12)) # Thu 2023-10-12
  end

  after { Timecop.return }

  describe '.parse_period' do
    test_cases = {
      { day:  '1' } => '2023-10-01..2023-10-02',
      { day: '31' } => '2023-10-31..2023-11-01',
      { day: 'sunday'    } => '2023-10-15..2023-10-16',
      { day: 'monday'    } => '2023-10-16..2023-10-17',
      { day: 'tuesday'   } => '2023-10-17..2023-10-18',
      { day: 'wednesday' } => '2023-10-18..2023-10-19',
      { day: 'thursday'  } => '2023-10-19..2023-10-20',
      { day: 'friday'    } => '2023-10-13..2023-10-14',
      { day: 'saturday'  } => '2023-10-14..2023-10-15',
      { day: 'sun' } => '2023-10-15..2023-10-16',
      { day: 'sat' } => '2023-10-14..2023-10-15',
      { day: 'thursday',  include_current: true } => '2023-10-12..2023-10-13',
      { day: 'wednesday', direction: :backward  } => '2023-10-11..2023-10-12',
      { day: 'thursday',  direction: :backward  } => '2023-10-05..2023-10-06',
      { day: 'thursday',  direction: :backward, include_current: true } => '2023-10-12..2023-10-13',

      { month:  '1' } => '2023-01-01..2023-02-01',
      { month: '12' } => '2023-12-01..2024-01-01',
      { month: 'january'  } => '2024-01-01..2024-02-01',
      { month: 'november' } => '2023-11-01..2023-12-01',
      { month: 'october'  } => '2024-10-01..2024-11-01',
      { month: 'december' } => '2023-12-01..2024-01-01',
      { month: 'jan' } => '2024-01-01..2024-02-01',
      { month: 'dec' } => '2023-12-01..2024-01-01',
    }

    test_cases.each do |input, expected|
      it "parses #{input}" do
        start_date, end_date = expected.split('..').map { |date| DateTime.parse(date) }
        range = described_class.parse_period(**input).range
        expect(range).to eq(start_date..end_date)
      end
    end
  end
end
