module Users
  class FindOrCreate
    include Service

    def call
      user = User.find_or_create_by(phone: normalized_phone)

      Service::Result.new(value: user)
    end

    private

    def normalized_phone
      phone.gsub(/\D/, '')
    end

    attr_accessor :phone
  end
end
