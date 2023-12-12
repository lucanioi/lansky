module LedgerEntries
  class CreateSpending
    include Runnable

    def run
      ActiveRecord::Base.transaction do
        return entry if entry.save

        raise 'LedgerEntry could not be created: ' \
              "#{entry.errors.full_messages.join(", ")}"
      end
    end

    private

    def entry
      @entry ||= LedgerEntry.new(
        category:,
        amount_cents:,
        entry_type: LedgerEntry.entry_types[:spending],
        recorded_at: DateTime.current,
        user:
      )
    end

    def category
      @category ||= LedgerCategories::FindOrCreate.run(name: category_name).value!
    end

    attr_accessor :user, :amount_cents, :category_name
  end
end
