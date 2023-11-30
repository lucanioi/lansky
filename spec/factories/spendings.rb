FactoryBot.define do
  factory :spending do
    category { SpendingCategory.find_or_create_by(name: 'Food') }
    amount_in_cents { 20_00 }
  end
end
