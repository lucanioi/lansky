FactoryBot.define do
  factory :ledger_entry do
    category { LedgerCategory.find_or_create_by(name: 'Food') }
    amount_cents { 20_00 }
    entry_type { :spending }
  end
end
