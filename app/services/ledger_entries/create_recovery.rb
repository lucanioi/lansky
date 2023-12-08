module LedgerEntries
  class CreateRecovery
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
        category: category,
        amount_cents: amount_cents,
        entry_type: LedgerEntry.entry_types[:recovery],
        recorded_at: DateTime.current,
        user: user
      )
    end

    def category
      @category ||=
        LedgerCategories::FindOrCreate.run(name: category_name).value
    end

    attr_accessor :user, :amount_cents, :category_name
  end
end
