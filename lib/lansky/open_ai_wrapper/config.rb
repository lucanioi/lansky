require 'singleton'
require 'yaml'

module Lansky
  module OpenAIWrapper
    class Config
      def initialize(config = nil)
        @config = config || load_config
      end

      def method_missing(method_name, *arguments, &block)
        if @config.has_key?(name = method_name.to_s)
          return self.class.new(@config[name]) if @config[name].is_a?(Hash)
          return @config[name]
        end

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        @config.has_key?(method_name.to_s) || super
      end

      private

      def load_config
        YAML.load_file(config_file_path).with_indifferent_access
      end

      def config_file_path
        Rails.root.join('config', 'openai.yml')
      end
    end
  end
end

