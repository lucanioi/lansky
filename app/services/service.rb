module Service
  extend ActiveSupport::Concern

  included do
    def initialize(params = {})
      define_accessor_methods(params)
    end

    def self.call(*args)
      result = new(*args).call
      result.is_a?(Result) ? result : Result.new(value: result)
    rescue StandardError => e
      Result.new(error: e)
    end

    private

    def define_accessor_methods(params)
      params.each { |k, v| send("#{k}=", v) }
    end
  end

  class Result
    attr_reader :error

    def initialize(value: nil, error: nil)
      @value = value
      @error = error
    end

    def value
      raise error if failure?

      @value
    end

    def success?
      error.nil?
    end

    def failure?
      !success?
    end
  end
end
