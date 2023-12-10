namespace :cli do
  desc 'Run the command line mode'
  task start: :environment do
    Lansky::CommandLineMode.run
  end
end
