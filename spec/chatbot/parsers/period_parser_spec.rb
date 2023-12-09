require 'rails_helper'

RSpec.describe Chatbot::Parsers::PeriodParser do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12))
  end

  after { Timecop.return }

  describe '.parse_period' do
    test_cases = {
      'yesterday' => 'Wed, 11 Oct 2023 00:00:00 +0000..Thu, 12 Oct 2023 00:00:00 +0000',
      'today'     => 'Thu, 12 Oct 2023 00:00:00 +0000..Fri, 13 Oct 2023 00:00:00 +0000',
      'tomorrow'  => 'Fri, 13 Oct 2023 00:00:00 +0000..Sat, 14 Oct 2023 00:00:00 +0000',

      'last week' => 'Mon, 02 Oct 2023 00:00:00 +0000..Mon, 09 Oct 2023 00:00:00 +0000',
      'this week' => 'Mon, 09 Oct 2023 00:00:00 +0000..Mon, 16 Oct 2023 00:00:00 +0000',
      'next week' => 'Mon, 16 Oct 2023 00:00:00 +0000..Mon, 23 Oct 2023 00:00:00 +0000',

      'last month' => 'Fri, 01 Sep 2023 00:00:00 +0000..Sun, 01 Oct 2023 00:00:00 +0000',
      'this month' => 'Sun, 01 Oct 2023 00:00:00 +0000..Wed, 01 Nov 2023 00:00:00 +0000',
      'next month' => 'Wed, 01 Nov 2023 00:00:00 +0000..Fri, 01 Dec 2023 00:00:00 +0000',

      'last year' => 'Sat, 01 Jan 2022 00:00:00 +0000..Sun, 01 Jan 2023 00:00:00 +0000',
      'this year' => 'Sun, 01 Jan 2023 00:00:00 +0000..Mon, 01 Jan 2024 00:00:00 +0000',
      'next year' => 'Mon, 01 Jan 2024 00:00:00 +0000..Wed, 01 Jan 2025 00:00:00 +0000',

      ['monday',    { direction: :forward  }] => 'Mon, 16 Oct 2023 00:00:00 +0000..Tue, 17 Oct 2023 00:00:00 +0000',
      ['monday',    { direction: :backward }] => 'Mon, 09 Oct 2023 00:00:00 +0000..Tue, 10 Oct 2023 00:00:00 +0000',
      ['tuesday',   { direction: :forward  }] => 'Tue, 17 Oct 2023 00:00:00 +0000..Wed, 18 Oct 2023 00:00:00 +0000',
      ['tuesday',   { direction: :backward }] => 'Tue, 10 Oct 2023 00:00:00 +0000..Wed, 11 Oct 2023 00:00:00 +0000',
      ['wednesday', { direction: :forward  }] => 'Wed, 18 Oct 2023 00:00:00 +0000..Thu, 19 Oct 2023 00:00:00 +0000',
      ['wednesday', { direction: :backward }] => 'Wed, 11 Oct 2023 00:00:00 +0000..Thu, 12 Oct 2023 00:00:00 +0000',
      ['thursday',  { direction: :forward  }] => 'Thu, 19 Oct 2023 00:00:00 +0000..Fri, 20 Oct 2023 00:00:00 +0000',
      ['thursday',  { direction: :backward }] => 'Thu, 12 Oct 2023 00:00:00 +0000..Fri, 13 Oct 2023 00:00:00 +0000',
      ['friday',    { direction: :forward  }] => 'Fri, 20 Oct 2023 00:00:00 +0000..Sat, 21 Oct 2023 00:00:00 +0000',
      ['friday',    { direction: :backward }] => 'Fri, 13 Oct 2023 00:00:00 +0000..Sat, 14 Oct 2023 00:00:00 +0000',
      ['saturday',  { direction: :forward  }] => 'Sat, 21 Oct 2023 00:00:00 +0000..Sun, 22 Oct 2023 00:00:00 +0000',
      ['saturday',  { direction: :backward }] => 'Sat, 14 Oct 2023 00:00:00 +0000..Sun, 15 Oct 2023 00:00:00 +0000',
      ['sunday',    { direction: :forward  }] => 'Sun, 22 Oct 2023 00:00:00 +0000..Mon, 23 Oct 2023 00:00:00 +0000',
      ['sunday',    { direction: :backward }] => 'Sun, 15 Oct 2023 00:00:00 +0000..Mon, 16 Oct 2023 00:00:00 +0000',

      ['january',   { direction: :forward  }] => 'Mon, 01 Jan 2024 00:00:00 +0000..Fri, 01 Feb 2024 00:00:00 +0000',
      ['january',   { direction: :backward }] => 'Sun, 01 Jan 2023 00:00:00 +0000..Wed, 01 Feb 2023 00:00:00 +0000',
      ['february',  { direction: :forward  }] => 'Thu, 01 Feb 2024 00:00:00 +0000..Fri, 01 Mar 2024 00:00:00 +0000',
      ['february',  { direction: :backward }] => 'Wed, 01 Feb 2023 00:00:00 +0000..Wed, 01 Mar 2023 00:00:00 +0000',
      ['march',     { direction: :forward  }] => 'Fri, 01 Mar 2024 00:00:00 +0000..Mon, 01 Apr 2024 00:00:00 +0000',
      ['march',     { direction: :backward }] => 'Wed, 01 Mar 2023 00:00:00 +0000..Sat, 01 Apr 2023 00:00:00 +0000',
      ['april',     { direction: :forward  }] => 'Mon, 01 Apr 2024 00:00:00 +0000..Wed, 01 May 2024 00:00:00 +0000',
      ['april',     { direction: :backward }] => 'Sat, 01 Apr 2023 00:00:00 +0000..Mon, 01 May 2023 00:00:00 +0000',
      ['may',       { direction: :forward  }] => 'Wed, 01 May 2024 00:00:00 +0000..Sat, 01 Jun 2024 00:00:00 +0000',
      ['may',       { direction: :backward }] => 'Mon, 01 May 2023 00:00:00 +0000..Thu, 01 Jun 2023 00:00:00 +0000',
      ['june',      { direction: :forward  }] => 'Sat, 01 Jun 2024 00:00:00 +0000..Mon, 01 Jul 2024 00:00:00 +0000',
      ['june',      { direction: :backward }] => 'Thu, 01 Jun 2023 00:00:00 +0000..Sat, 01 Jul 2023 00:00:00 +0000',
      ['july',      { direction: :forward  }] => 'Mon, 01 Jul 2024 00:00:00 +0000..Thu, 01 Aug 2024 00:00:00 +0000',
      ['july',      { direction: :backward }] => 'Sat, 01 Jul 2023 00:00:00 +0000..Tue, 01 Aug 2023 00:00:00 +0000',
      ['august',    { direction: :forward  }] => 'Thu, 01 Aug 2024 00:00:00 +0000..Sun, 01 Sep 2024 00:00:00 +0000',
      ['august',    { direction: :backward }] => 'Tue, 01 Aug 2023 00:00:00 +0000..Fri, 01 Sep 2023 00:00:00 +0000',
      ['september', { direction: :forward  }] => 'Sun, 01 Sep 2024 00:00:00 +0000..Tue, 01 Oct 2024 00:00:00 +0000',
      ['september', { direction: :backward }] => 'Fri, 01 Sep 2023 00:00:00 +0000..Sun, 01 Oct 2023 00:00:00 +0000',
      ['october',   { direction: :forward  }] => 'Tue, 01 Oct 2024 00:00:00 +0000..Fri, 01 Nov 2024 00:00:00 +0000',
      ['october',   { direction: :backward }] => 'Sat, 01 Oct 2022 00:00:00 +0000..Tue, 01 Nov 2022 00:00:00 +0000',
      ['november',  { direction: :forward  }] => 'Wed, 01 Nov 2023 00:00:00 +0000..Fri, 01 Dec 2023 00:00:00 +0000',
      ['november',  { direction: :backward }] => 'Tue, 01 Nov 2022 00:00:00 +0000..Thu, 01 Dec 2022 00:00:00 +0000',
      ['december',  { direction: :forward  }] => 'Fri, 01 Dec 2023 00:00:00 +0000..Mon, 01 Jan 2024 00:00:00 +0000',
      ['december',  { direction: :backward }] => 'Thu, 01 Dec 2022 00:00:00 +0000..Sun, 01 Jan 2023 00:00:00 +0000',

      # default direction is :forward
      'monday'  => 'Mon, 16 Oct 2023 00:00:00 +0000..Tue, 17 Oct 2023 00:00:00 +0000',
      'january' => 'Mon, 01 Jan 2024 00:00:00 +0000..Thu, 01 Feb 2024 00:00:00 +0000',

      # include current
      ['october',   { direction: :forward,  include_current: true }] => 'Sun, 01 Oct 2023 00:00:00 +0000..Wed, 01 Nov 2023 00:00:00 +0000',
      ['october',   { direction: :backward, include_current: true }] => 'Sun, 01 Oct 2023 00:00:00 +0000..Wed, 01 Nov 2023 00:00:00 +0000',
    }

    test_cases.each do |input, expected|
      it "parses #{input}" do
        if input.is_a?(Array)
          input, options = input
          expect(described_class.parse_period_single(input, **options).range.inspect).to eq(expected)
        else
          expect(described_class.parse_period_single(input).range.inspect).to eq(expected)
        end
      end
    end
  end
end
