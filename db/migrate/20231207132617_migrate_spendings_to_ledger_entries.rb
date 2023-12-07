class MigrateSpendingsToLedgerEntries < ActiveRecord::Migration[7.1]
  def up
    Spending.find_each do |spending|
      category = LedgerCategory.find_or_create_by!(name: spending.spending_category.name)

      LedgerEntry.create!(
        amount_cents: spending.amount_cents,
        category: category,
        user_id: spending.user_id,
        entry_type: :expense,
        created_at: spending.created_at,
        updated_at: spending.updated_at
      )
    end
  end

  def down
    LedgerEntry.destroy_all
    LedgerCategory.destroy_all
  end
end
