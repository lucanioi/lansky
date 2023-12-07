FactoryBot.define do
  factory :ledger_entry do
    amount_cents { 1 }
    category { nil }
    user { nil }
    entry_type { 1 }
  end
end
