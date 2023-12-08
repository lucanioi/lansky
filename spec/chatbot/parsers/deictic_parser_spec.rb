require 'rails_helper'

RSpec.describe Chatbot::Parsers::DeicticParser do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12)) # Thu, 12 Oct 2023 00:00
  end

  after { Timecop.return }

  describe '.parse_period' do
    test_cases = {
      { day: 'yesterday' }    => '2023-10-11..2023-10-12',
      { day: 'today' }        => '2023-10-12..2023-10-13',
      { day: 'tomorrow' }     => '2023-10-13..2023-10-14',
      { day: 'last tuesday' } => '2023-10-10..2023-10-11',
      { day: 'next friday'}   => '2023-10-13..2023-10-14',

      { week: 'last week' } => '2023-10-02..2023-10-09',
      { week: 'this week' } => '2023-10-09..2023-10-16',
      { week: 'next week' } => '2023-10-16..2023-10-23',

      { month: 'last month'  } => '2023-09-01..2023-10-01',
      { month: 'this month'  } => '2023-10-01..2023-11-01',
      { month: 'next month'  } => '2023-11-01..2023-12-01',
      { month: 'last august' } => '2023-08-01..2023-09-01',

      { year: 'last year' } => '2022-01-01..2023-01-01',
      { year: 'this year' } => '2023-01-01..2024-01-01',
      { year: 'next year' } => '2024-01-01..2025-01-01',

      # day-week combo
      { day: 'wednesday', week: 'last week' } => '2023-10-04..2023-10-05',
      { day: 'tuesday',   week: 'this week' } => '2023-10-10..2023-10-11',
      { day: 'thursday',  week: 'next week' } => '2023-10-19..2023-10-20',

      # day-month combo
      { day: '1',  month: 'last month' } => '2023-09-01..2023-09-02',
      { day: '23', month: 'next month' } => '2023-11-23..2023-11-24',

      # week-month combo
      { week: '3', month: 'last month' }  => '2023-09-18..2023-09-25',
      { week: '2', month: 'next month' }  => '2023-11-06..2023-11-13',
      { week: '1', month: 'last august' } => '2023-07-31..2023-08-07',
      { week: '4', month: 'next august' } => '2024-08-19..2024-08-26',

      # month-year combo
      { month: 'august',    year: 'last year' } => '2022-08-01..2022-09-01',
      { month: 'september', year: 'this year' } => '2023-09-01..2023-10-01',
      { month: 'october',   year: 'next year' } => '2024-10-01..2024-11-01',
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
