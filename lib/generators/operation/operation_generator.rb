require 'rails/generators'

class OperationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  argument :params, type: :array, default: [], banner: "param1 param2 param3"

  def create_operation_file
    template 'operation.erb',
            File.join("app/chatbot/chatbot/operations", "#{file_name}.rb")
  end

  def create_operation_spec_file
    template 'operation_spec.erb',
            File.join('spec/chatbot/operations', "#{file_name}_spec.rb")
  end

  def create_params_file
    return if params.empty?

    template 'params.erb',
            File.join("app/chatbot/chatbot/params", "#{file_name}.rb")
  end
end
