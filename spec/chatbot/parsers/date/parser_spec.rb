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
      { day: 'monday'    } => '2023-10-09..2023-10-10',
      { day: 'tuesday'   } => '2023-10-10..2023-10-11',
      { day: 'wednesday' } => '2023-10-11..2023-10-12',
      { day: 'thursday'  } => '2023-10-12..2023-10-13',
      { day: 'friday'    } => '2023-10-13..2023-10-14',
      { day: 'saturday'  } => '2023-10-14..2023-10-15',
      { day: 'sunday'    } => '2023-10-15..2023-10-16',
      { day: 'sun' } => '2023-10-15..2023-10-16',
      { day: 'sat' } => '2023-10-14..2023-10-15',
      { day: 'thursday',  include_current: false } => '2023-10-12..2023-10-13', # include_current is only effective when direction is not :current
      { day: 'wednesday', direction: :current  } => '2023-10-11..2023-10-12',
      { day: 'friday',    direction: :backward } => '2023-10-06..2023-10-07',
      { day: 'wednesday', direction: :forward  } => '2023-10-18..2023-10-19',
      { day: 'thursday',  direction: :backward, include_current: true } => '2023-10-12..2023-10-13',

      { week: '1' } => '2023-10-02..2023-10-09',
      { week: '2' } => '2023-10-09..2023-10-16',
      { week: '3' } => '2023-10-16..2023-10-23',
      { week: '4' } => '2023-10-23..2023-10-30',
      { week: '5' } => '2023-10-30..2023-11-06',

      { month:  '1' } => '2023-01-01..2023-02-01',
      { month: '12' } => '2023-12-01..2024-01-01',
      { month: 'january'  } => '2023-01-01..2023-02-01',
      { month: 'november' } => '2023-11-01..2023-12-01',
      { month: 'october'  } => '2023-10-01..2023-11-01',
      { month: 'december' } => '2023-12-01..2024-01-01',
      { month: 'jan' } => '2023-01-01..2023-02-01',
      { month: 'dec' } => '2023-12-01..2024-01-01',
      { month: 'january',  direction: :forward } => '2024-01-01..2024-02-01',
      { month: 'december', direction: :backward } => '2022-12-01..2023-01-01',
      { month: 'october',  direction: :backward, include_current: false } => '2022-10-01..2022-11-01',
      { month: 'october',  direction: :forward,  include_current: false } => '2024-10-01..2024-11-01',

      { year: '2020' } => '2020-01-01..2021-01-01',
      { year: '2023' } => '2023-01-01..2024-01-01',
      { year: '2025' } => '2025-01-01..2026-01-01',

      # combos

      # 2 components
      { day:  '1', month: '1'        } => '2023-01-01..2023-01-02',
      { day: '13', month: 'november' } => '2023-11-13..2023-11-14',
      { day: '13', month: 'october', include_current: true } => '2023-10-13..2023-10-14',

      { day: 'monday', week: '1' } => '2023-10-02..2023-10-03',
      { day: 'sunday', week: '4' } => '2023-10-29..2023-10-30',

      { week: '1', month:  '9' } => '2023-09-04..2023-09-11',
      { week: '3', month: '10' } => '2023-10-16..2023-10-23',

      { month: '1',       year: '2020' } => '2020-01-01..2020-02-01',
      { month: 'january', year: '2020' } => '2020-01-01..2020-02-01',

      # 3 components
      { day: 'wednesday', week: '3', month: 'january'  } => '2023-01-18..2023-01-19',
      { day: 'sunday',    week: '4', month: 'december' } => '2023-12-31..2024-01-01',

      { week: '1', month: 'february', year: '2022' } => '2022-01-31..2022-02-07',

      { day: '24', month: '3', year: '2024' } => '2024-03-24..2024-03-25',

      # 4 components
      { day: 'monday', week: '4', month: 'june', year: '2024' } => '2024-06-24..2024-06-25',
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
