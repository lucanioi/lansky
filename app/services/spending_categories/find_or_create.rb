module SpendingCategories
  class FindOrCreate < ApplicationService
    attr_reader :name

    def initialize(name:)
      @name = normalize(name)
    end

    def call
      find_or_create
    end

    private

    def find_or_create
      SpendingCategory.find_or_create_by(name: name)
    end

    def normalize(name)
      name.downcase.strip
    end
  end
end
