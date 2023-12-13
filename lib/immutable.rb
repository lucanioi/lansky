module Immutable
  extend ActiveSupport::Concern

  included do
    prepend InstanceMethods
  end

  module InstanceMethods
    def initialize(*args, &block)
      super(*args, &block)

      instance_variables.each do |var|
        instance_variable_set(var, instance_variable_get(var).freeze)
      end

      freeze
    end
  end
end
