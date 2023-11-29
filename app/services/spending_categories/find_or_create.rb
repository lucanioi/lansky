module SpendingCategories
  class FindOrCreate
    include Service

    def call
      find_or_create
    end

    private

    def find_or_create
      SpendingCategory.find_or_create_by(name: normalized_name)
    end

    def normalized_name
      return SpendingCategory::UNCATEGORIZED unless name

      name.downcase.strip
    end

    attr_accessor :name
  end
end