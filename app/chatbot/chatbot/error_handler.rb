require_relative 'engines/classic/parsers/errors'
require_relative 'helpers/date_time_helper'

module Chatbot
  module ErrorHandler
    module_function

    ERRORS = {
      Engines::Classic::Router::UnknownOperation => {
        friendly_message: 'Did not understand'
      },
      Engines::Classic::Parsers::InvalidAmount => {
        friendly_message: 'Invalid amount'
      },
      Helpers::DateTimeHelper::InvalidPeriod => {
        friendly_message: "Invalid period"
      },
      Engines::Classic::Parsers::DateExtractor::InvalidPeriod => {
        friendly_message: "Invalid period"
      }
    }.freeze

    def handle_error(error)
      raise error unless error.is_a? Lansky::DisplayableError
      raise error unless ERRORS.key? error.class

      ERRORS[error.class][:friendly_message]
    end
  end
end
