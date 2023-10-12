module Service
  extend ActiveSupport::Concern

  included do
    def initialize(params = {})
      define_accessor_methods(params)
    end

    def self.call(*args)
      Result.new(value: new(*args).call)
    rescue StandardError => e
      Result.new(error: e)
    end

    private

    def define_accessor_methods(params)
      params.each { |k, v| send("#{k}=", v) }
    end
  end

  class Result
    attr_reader :value, :error

    def initialize(value: nil, error: nil)
      @value = value
      @error = error
    end

    def success?
      error.nil?
    end

    def failure?
      !success?
    end
  end
end
