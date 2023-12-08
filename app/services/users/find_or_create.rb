module Users
  class FindOrCreate
    include Runnable

    def run
      User.find_or_create_by(phone: normalized_phone)
    end

    private

    def normalized_phone
      phone.gsub(/\D/, '')
    end

    attr_accessor :phone
  end
end
