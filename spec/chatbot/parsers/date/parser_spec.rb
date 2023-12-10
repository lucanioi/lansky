require 'rails_helper'

RSpec.describe Chatbot::Parsers::Date::Parser do
  before do
    Timecop.freeze(DateTime.parse('2023-10-12 12:34:00')) # Thu 12 Oct 2023
  end

  after { Timecop.return }

  describe '.parse_from_params' do
    test_cases = {
      { day:  '1' } => '2023-10-01..2023-10-02',
      { day: '31' } => '2023-10-31..2023-11-01',
      { day: 'mon' } => '2023-10-09..2023-10-10',
      { day: 'tue' } => '2023-10-10..2023-10-11',
      { day: 'wed' } => '2023-10-11..2023-10-12',
      { day: 'thu' } => '2023-10-12..2023-10-13',
      { day: 'fri' } => '2023-10-13..2023-10-14',
      { day: 'sat' } => '2023-10-14..2023-10-15',
      { day: 'sun' } => '2023-10-15..2023-10-16',
      { day: 'next wed' } => '2023-10-18..2023-10-19',
      { day: 'next thu' } => '2023-10-19..2023-10-20',
      { day: 'today'     } => '2023-10-12..2023-10-13',
      { day: 'tomorrow'  } => '2023-10-13..2023-10-14',
      { day: 'yesterday' } => '2023-10-11..2023-10-12',
      { day: 'thu', include_current: false } => '2023-10-12..2023-10-13', # include_current is ignored unless direction is :forward or :backward
      { day: 'wed', direction: :current  } => '2023-10-11..2023-10-12',
      { day: 'fri', direction: :backward } => '2023-10-06..2023-10-07',
      { day: 'wed', direction: :forward  } => '2023-10-18..2023-10-19',
      { day: 'thu', direction: :backward, include_current: true } => '2023-10-12..2023-10-13',
      { day: 'toilet' } => Chatbot::Parsers::Date::Day::InvalidDay,

      { week: '1' } => '2023-10-02..2023-10-09',
      { week: '2' } => '2023-10-09..2023-10-16',
      { week: '3' } => '2023-10-16..2023-10-23',
      { week: '4' } => '2023-10-23..2023-10-30',
      { week: '5' } => '2023-10-30..2023-11-06',
      { week: 'this' } => '2023-10-09..2023-10-16',
      { week: 'next' } => '2023-10-16..2023-10-23',
      { week: 'prev' } => '2023-10-02..2023-10-09',
      { week: 'next week' } => '2023-10-16..2023-10-23',
      { set_date: '2023-10-31', week: 'next' } => '2023-11-06..2023-11-13', # changes month
      { week: 'toilet' } => Chatbot::Parsers::Date::Week::InvalidWeek,

      { month: 'jan'  } => '2023-01-01..2023-02-01',
      { month: 'feb'  } => '2023-02-01..2023-03-01',
      { month: 'mar'  } => '2023-03-01..2023-04-01',
      { month: 'apr'  } => '2023-04-01..2023-05-01',
      { month: 'may'  } => '2023-05-01..2023-06-01',
      { month: 'jun'  } => '2023-06-01..2023-07-01',
      { month: 'jul'  } => '2023-07-01..2023-08-01',
      { month: 'aug'  } => '2023-08-01..2023-09-01',
      { month: 'sep'  } => '2023-09-01..2023-10-01',
      { month: 'oct'  } => '2023-10-01..2023-11-01',
      { month: 'nov' } => '2023-11-01..2023-12-01',
      { month: 'dec' } => '2023-12-01..2024-01-01',
      { month: 'this' } => '2023-10-01..2023-11-01',
      { month: 'next' } => '2023-11-01..2023-12-01',
      { month: 'prev' } => '2023-09-01..2023-10-01',
      { month: 'next month' } => '2023-11-01..2023-12-01',
      { month: 'next jan'  } => '2024-01-01..2024-02-01',
      { month: 'next dec' } => '2023-12-01..2024-01-01',
      { month: 'prev dec' } => '2022-12-01..2023-01-01',
      { month: 'jan', direction: :forward  } => '2024-01-01..2024-02-01',
      { month: 'dec', direction: :backward } => '2022-12-01..2023-01-01',
      { month: 'oct', direction: :backward, include_current: false } => '2022-10-01..2022-11-01',
      { month: 'oct', direction: :forward,  include_current: false } => '2024-10-01..2024-11-01',
      { month: 'toilet' } => Chatbot::Parsers::Date::Month::InvalidMonth,

      { year: '2020' } => '2020-01-01..2021-01-01',
      { year: '2023' } => '2023-01-01..2024-01-01',
      { year: '2025' } => '2025-01-01..2026-01-01',
      { year: 'this' } => '2023-01-01..2024-01-01',
      { year: 'next' } => '2024-01-01..2025-01-01',
      { year: 'prev' } => '2022-01-01..2023-01-01',
      { year: 'prev year' } => '2022-01-01..2023-01-01',
      { year: 'toilet' } => Chatbot::Parsers::Date::Year::InvalidYear,

      # combos

      # 2 components
      { day:  '1', month: 'jan' } => '2023-01-01..2023-01-02',
      { day: '13', month: 'nov' } => '2023-11-13..2023-11-14',
      { day: '13', month: 'oct' } => '2023-10-13..2023-10-14',
      { day: '30', month: 'next'     } => '2023-11-30..2023-12-01',
      { day: '30', month: 'next oct' } => '2024-10-30..2024-10-31',

      { day: 'mon', week: '1' } => '2023-10-02..2023-10-03',
      { day: 'sun', week: '4' } => '2023-10-29..2023-10-30',
      { day: 'sun', week: 'next' } => '2023-10-22..2023-10-23',

      { week: '1', month: 'sep'  } => '2023-09-04..2023-09-11',
      { week: '3', month: 'oct'  } => '2023-10-16..2023-10-23',
      { week: '3', month: 'next' } => '2023-11-13..2023-11-20',

      { month: 'jan', year: '2020' } => '2020-01-01..2020-02-01',

      # 3 components
      { day: 'wed', week: '3', month:      'jan' } => '2023-01-18..2023-01-19',
      { day: 'sun', week: '4', month:      'dec' } => '2023-12-31..2024-01-01',
      { day: 'sun', week: '4', month: 'prev dec' } => '2022-12-25..2022-12-26',

      { week: '1', month: 'feb', year: '2022' } => '2022-01-31..2022-02-07',
      { day: '24', month: 'mar', year: '2024' } => '2024-03-24..2024-03-25',

      # 4 components
      { day: 'mon', week: '4', month: 'jun', year: '2024' } => '2024-06-24..2024-06-25',
      { day: 'sun', week: '1', month: 'apr', year: '2022' } => '2022-04-10..2022-04-11',
      { day: 'sun', week: '1', month: 'apr', year: 'prev' } => '2022-04-10..2022-04-11',
      { day: 'sun', week: '1', month: 'apr', year: 'next' } => '2024-04-07..2024-04-08',
    }

    test_cases.each do |input, expected|
      it "parses #{input}" do
        if input[:set_date]
          Timecop.freeze(DateTime.parse(input[:set_date]))
        end

        input = input.except(:set_date)

        if expected.is_a?(Class)
          expect { described_class.parse_from_params(**input) }.to raise_error(expected)
        else
          start_date, end_date = expected.split('..').map { |date| DateTime.parse(date) }
          range = described_class.parse_from_params(**input).range
          expect(range).to eq(start_date..end_date)
        end
      end
    end
  end

  # describe '.parse_from_string' do
  #   test_cases = {
  #     { string: '2023' } => '2023-01-01..2024-01-01',
  #     { string: 'oct' } => '2023-10-01..2023-11-01',
  #   }

  #   test_cases.each do |input, expected|
  #     it "parses #{input}" do
  #       if expected.is_a?(Class)
  #         expect { described_class.parse_from_string(**input) }.to raise_error(expected)
  #       else
  #         start_date, end_date = expected.split('..').map { |date| DateTime.parse(date) }
  #         range = described_class.parse_from_string(**input).range
  #         expect(range).to eq(start_date..end_date)
  #       end
  #     end
  #   end
  # end
end
