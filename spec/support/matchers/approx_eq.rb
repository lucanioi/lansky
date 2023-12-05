RSpec::Matchers.define :approx_eq do |expected|
  match do |actual|
    tolerance = 0.001

    actual   = actual.to_datetime if actual.is_a?(Date)
    expected = expected.to_datetime if expected.is_a?(Date)

    (actual - expected).abs <= tolerance
  end

  failure_message do |actual|
    "expected #{actual} to be within ±0.001 of #{expected}"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} to not be within ±0.001 of #{expected}"
  end

  description do
    "be within ±0.001 of #{expected}"
  end
end
