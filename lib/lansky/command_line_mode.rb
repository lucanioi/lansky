require_relative '../runnable'

module Lansky
  class CommandLineMode
    include Runnable

    CLI_USER_PHONE = '888888888'.freeze
    EXIT_MESSAGE = /exit!?|quit?!/.freeze

    def run
      loop do
        puts 'message:'.green
        print '> '
        input = STDIN.gets.chomp
        message = normalize_input(input)
        break if message.match?(EXIT_MESSAGE)

        reply = get_reply(input)
        puts "\nreply:".green
        puts "#{reply}\n\n"
      rescue StandardError => e
        puts "\nerror:\n#{e}\n\n".light_red
        puts e.backtrace.take(10).join("\n").red
      end
    end

    private

    def get_reply(message)
      Chatbot::Engine.run(user:, message:, mode:).value!
    end

    def user
      @user ||= User.find_or_create_by!(phone: CLI_USER_PHONE, test_user: true)
    end

    def normalize_input(message)
      message.downcase.gsub(/\s+/, ' ').strip
    end

    def mode
      :ai
    end
  end
end
