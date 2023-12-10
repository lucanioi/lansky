require_relative '../runnable'

module Lansky
  class CommandLineMode
    include Runnable

    CLI_USER_PHONE = '888888888'.freeze
    EXIT_MESSAGE = /exit!?|quit?!/.freeze

    def run
      loop do
        puts Rails.env
        puts 'message:'
        print '> '
        input = STDIN.gets.chomp
        message = normalize_input(input)
        break if message.match?(EXIT_MESSAGE)

        reply = get_reply(input)
        puts "\nreply:\n#{reply}\n\n"
      end
    end

    private

    def get_reply(message)
      Chatbot::Engine.run(user:, message:).value!
    end

    def user
      @user ||= User.find_or_create_by!(phone: CLI_USER_PHONE, test_user: true)
    end

    def normalize_input(message)
      message.downcase.gsub(/\s+/, ' ').strip
    end
  end
end
