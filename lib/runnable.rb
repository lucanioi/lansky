module Runnable
  extend ActiveSupport::Concern

  included do
    def initialize(**args)
      define_accessor_methods(args)
    end

    def self.run(**args)
      result = new(**args).run
      result.is_a?(Result) ? result : Result.new(value: result)
    rescue StandardError => e
      Result.new(error: e)
    end

    private

    def define_accessor_methods(args)
      args.each { |k, v| send("#{k}=", v) }
    end
  end

  class Result
    attr_reader :error, :value

    def initialize(value: nil, error: nil)
      @value = value
      @error = error
    end

    def value!
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
