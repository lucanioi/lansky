FactoryBot.define do
  factory :budget do
    period_start { '2023-10-12 03:22:05' }
    period_end { '2023-10-12 03:22:05' }
    amount_in_cents { 2_000_00 }
  end
end
