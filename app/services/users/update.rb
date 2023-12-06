module Users
  class Update
    include Service

    UPDATABLE_ATTRIBUTES = %i[timezone].freeze

    def call
      params.slice(*UPDATABLE_ATTRIBUTES).each do |key, value|
        user.send("#{key}=", value)
      end

      user.save!
    end

    private

    attr_accessor :user, :params
  end
end
