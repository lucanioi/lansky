module LedgerEntries
  class CreateSpending
    include Service

    def call
      return entry if entry.save

      raise 'LedgerEntry could not be created: ' \
            "#{spending.errors.full_messages.join(", ")}"
    end

    private

    def entry
      @entry ||= LedgerEntry.new(
        category: category,
        amount_cents: amount_cents,
        entry_type: LedgerEntry.entry_types[:spending],
        recorded_at: DateTime.current,
        user: user
      )
    end

    attr_accessor :category, :amount_cents, :user
  end
end
