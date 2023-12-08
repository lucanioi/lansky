module Users
  class Update
    include Runnable

    UPDATABLE_ATTRIBUTES = %i[timezone currency].freeze

    def run
      params.slice(*UPDATABLE_ATTRIBUTES).each do |key, value|
        user.send("#{key}=", value)
      end

      user.save!
    end

    private

    attr_accessor :user, :params
  end
end
