require 'rails_helper'

RSpec.describe Chatbot::DateTimeHelper do
  before do
    Timecop.freeze(DateTime.new(2023, 10, 12))
  end

  after { Timecop.return }

  describe '.parse_period' do
    test_cases = {
      'yesterday' => 'Wed, 11 Oct 2023 00:00:00.000000000 UTC +00:00..Wed, 11 Oct 2023 23:59:59.999999999 UTC +00:00',
      'today'     => 'Thu, 12 Oct 2023 00:00:00.000000000 UTC +00:00..Thu, 12 Oct 2023 23:59:59.999999999 UTC +00:00',
      'tomorrow'  => 'Fri, 13 Oct 2023 00:00:00.000000000 UTC +00:00..Fri, 13 Oct 2023 23:59:59.999999999 UTC +00:00',

      'last week' => 'Mon, 02 Oct 2023 00:00:00.000000000 UTC +00:00..Sun, 08 Oct 2023 23:59:59.999999999 UTC +00:00',
      'this week' => 'Mon, 09 Oct 2023 00:00:00.000000000 UTC +00:00..Sun, 15 Oct 2023 23:59:59.999999999 UTC +00:00',
      'next week' => 'Mon, 16 Oct 2023 00:00:00.000000000 UTC +00:00..Sun, 22 Oct 2023 23:59:59.999999999 UTC +00:00',

      'last month' => 'Fri, 01 Sep 2023 00:00:00.000000000 UTC +00:00..Sat, 30 Sep 2023 23:59:59.999999999 UTC +00:00',
      'this month' => 'Sun, 01 Oct 2023 00:00:00.000000000 UTC +00:00..Tue, 31 Oct 2023 23:59:59.999999999 UTC +00:00',
      'next month' => 'Wed, 01 Nov 2023 00:00:00.000000000 UTC +00:00..Thu, 30 Nov 2023 23:59:59.999999999 UTC +00:00',

      'last year' => 'Sat, 01 Jan 2022 00:00:00.000000000 UTC +00:00..Sat, 31 Dec 2022 23:59:59.999999999 UTC +00:00',
      'this year' => 'Sun, 01 Jan 2023 00:00:00.000000000 UTC +00:00..Sun, 31 Dec 2023 23:59:59.999999999 UTC +00:00',
      'next year' => 'Mon, 01 Jan 2024 00:00:00.000000000 UTC +00:00..Tue, 31 Dec 2024 23:59:59.999999999 UTC +00:00',

      ['monday',    { direction: :forward  }] => 'Mon, 16 Oct 2023 00:00:00.000000000 UTC +00:00..Mon, 16 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['monday',    { direction: :backward }] => 'Mon, 09 Oct 2023 00:00:00.000000000 UTC +00:00..Mon, 09 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['tuesday',   { direction: :forward  }] => 'Tue, 17 Oct 2023 00:00:00.000000000 UTC +00:00..Tue, 17 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['tuesday',   { direction: :backward }] => 'Tue, 10 Oct 2023 00:00:00.000000000 UTC +00:00..Tue, 10 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['wednesday', { direction: :forward  }] => 'Wed, 18 Oct 2023 00:00:00.000000000 UTC +00:00..Wed, 18 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['wednesday', { direction: :backward }] => 'Wed, 11 Oct 2023 00:00:00.000000000 UTC +00:00..Wed, 11 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['thursday',  { direction: :forward  }] => 'Thu, 19 Oct 2023 00:00:00.000000000 UTC +00:00..Thu, 19 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['thursday',  { direction: :backward }] => 'Thu, 05 Oct 2023 00:00:00.000000000 UTC +00:00..Thu, 05 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['friday',    { direction: :forward  }] => 'Fri, 13 Oct 2023 00:00:00.000000000 UTC +00:00..Fri, 13 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['friday',    { direction: :backward }] => 'Fri, 06 Oct 2023 00:00:00.000000000 UTC +00:00..Fri, 06 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['saturday',  { direction: :forward  }] => 'Sat, 14 Oct 2023 00:00:00.000000000 UTC +00:00..Sat, 14 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['saturday',  { direction: :backward }] => 'Sat, 07 Oct 2023 00:00:00.000000000 UTC +00:00..Sat, 07 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['sunday',    { direction: :forward  }] => 'Sun, 15 Oct 2023 00:00:00.000000000 UTC +00:00..Sun, 15 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['sunday',    { direction: :backward }] => 'Sun, 08 Oct 2023 00:00:00.000000000 UTC +00:00..Sun, 08 Oct 2023 23:59:59.999999999 UTC +00:00',

      ['january',   { direction: :forward  }] => 'Mon, 01 Jan 2024 00:00:00.000000000 UTC +00:00..Wed, 31 Jan 2024 23:59:59.999999999 UTC +00:00',
      ['january',   { direction: :backward }] => 'Sun, 01 Jan 2023 00:00:00.000000000 UTC +00:00..Tue, 31 Jan 2023 23:59:59.999999999 UTC +00:00',
      ['february',  { direction: :forward  }] => 'Thu, 01 Feb 2024 00:00:00.000000000 UTC +00:00..Thu, 29 Feb 2024 23:59:59.999999999 UTC +00:00',
      ['february',  { direction: :backward }] => 'Wed, 01 Feb 2023 00:00:00.000000000 UTC +00:00..Tue, 28 Feb 2023 23:59:59.999999999 UTC +00:00',
      ['march',     { direction: :forward  }] => 'Fri, 01 Mar 2024 00:00:00.000000000 UTC +00:00..Sun, 31 Mar 2024 23:59:59.999999999 UTC +00:00',
      ['march',     { direction: :backward }] => 'Wed, 01 Mar 2023 00:00:00.000000000 UTC +00:00..Fri, 31 Mar 2023 23:59:59.999999999 UTC +00:00',
      ['april',     { direction: :forward  }] => 'Mon, 01 Apr 2024 00:00:00.000000000 UTC +00:00..Tue, 30 Apr 2024 23:59:59.999999999 UTC +00:00',
      ['april',     { direction: :backward }] => 'Sat, 01 Apr 2023 00:00:00.000000000 UTC +00:00..Sun, 30 Apr 2023 23:59:59.999999999 UTC +00:00',
      ['may',       { direction: :forward  }] => 'Wed, 01 May 2024 00:00:00.000000000 UTC +00:00..Fri, 31 May 2024 23:59:59.999999999 UTC +00:00',
      ['may',       { direction: :backward }] => 'Mon, 01 May 2023 00:00:00.000000000 UTC +00:00..Wed, 31 May 2023 23:59:59.999999999 UTC +00:00',
      ['june',      { direction: :forward  }] => 'Sat, 01 Jun 2024 00:00:00.000000000 UTC +00:00..Sun, 30 Jun 2024 23:59:59.999999999 UTC +00:00',
      ['june',      { direction: :backward }] => 'Thu, 01 Jun 2023 00:00:00.000000000 UTC +00:00..Fri, 30 Jun 2023 23:59:59.999999999 UTC +00:00',
      ['july',      { direction: :forward  }] => 'Mon, 01 Jul 2024 00:00:00.000000000 UTC +00:00..Wed, 31 Jul 2024 23:59:59.999999999 UTC +00:00',
      ['july',      { direction: :backward }] => 'Sat, 01 Jul 2023 00:00:00.000000000 UTC +00:00..Mon, 31 Jul 2023 23:59:59.999999999 UTC +00:00',
      ['august',    { direction: :forward  }] => 'Thu, 01 Aug 2024 00:00:00.000000000 UTC +00:00..Sat, 31 Aug 2024 23:59:59.999999999 UTC +00:00',
      ['august',    { direction: :backward }] => 'Tue, 01 Aug 2023 00:00:00.000000000 UTC +00:00..Thu, 31 Aug 2023 23:59:59.999999999 UTC +00:00',
      ['september', { direction: :forward  }] => 'Sun, 01 Sep 2024 00:00:00.000000000 UTC +00:00..Mon, 30 Sep 2024 23:59:59.999999999 UTC +00:00',
      ['september', { direction: :backward }] => 'Fri, 01 Sep 2023 00:00:00.000000000 UTC +00:00..Sat, 30 Sep 2023 23:59:59.999999999 UTC +00:00',
      ['october',   { direction: :forward  }] => 'Tue, 01 Oct 2024 00:00:00.000000000 UTC +00:00..Thu, 31 Oct 2024 23:59:59.999999999 UTC +00:00',
      ['october',   { direction: :backward }] => 'Sat, 01 Oct 2022 00:00:00.000000000 UTC +00:00..Mon, 31 Oct 2022 23:59:59.999999999 UTC +00:00',
      ['november',  { direction: :forward  }] => 'Wed, 01 Nov 2023 00:00:00.000000000 UTC +00:00..Thu, 30 Nov 2023 23:59:59.999999999 UTC +00:00',
      ['november',  { direction: :backward }] => 'Tue, 01 Nov 2022 00:00:00.000000000 UTC +00:00..Wed, 30 Nov 2022 23:59:59.999999999 UTC +00:00',
      ['december',  { direction: :forward  }] => 'Fri, 01 Dec 2023 00:00:00.000000000 UTC +00:00..Sun, 31 Dec 2023 23:59:59.999999999 UTC +00:00',
      ['december',  { direction: :backward }] => 'Thu, 01 Dec 2022 00:00:00.000000000 UTC +00:00..Sat, 31 Dec 2022 23:59:59.999999999 UTC +00:00',

      # default direction is :forward
      'monday'  => 'Mon, 16 Oct 2023 00:00:00.000000000 UTC +00:00..Mon, 16 Oct 2023 23:59:59.999999999 UTC +00:00',
      'january' => 'Mon, 01 Jan 2024 00:00:00.000000000 UTC +00:00..Wed, 31 Jan 2024 23:59:59.999999999 UTC +00:00',

      # include current
      ['october',   { direction: :forward,  include_current: true }] => 'Sun, 01 Oct 2023 00:00:00.000000000 UTC +00:00..Tue, 31 Oct 2023 23:59:59.999999999 UTC +00:00',
      ['october',   { direction: :backward, include_current: true }] => 'Sun, 01 Oct 2023 00:00:00.000000000 UTC +00:00..Tue, 31 Oct 2023 23:59:59.999999999 UTC +00:00',
    }

    test_cases.each do |input, expected|
      it "parses #{input}" do
        if input.is_a?(Array)
          input, options = input
          expect(described_class.parse_period(input, **options).inspect).to eq(expected)
        else
          expect(described_class.parse_period(input).inspect).to eq(expected)
        end
      end
    end
  end
end
