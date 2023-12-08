source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# Use postgresql as the database for Active Record
gem "pg"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# for receiving message via SMS/Whatsapp
gem 'twilio-ruby', '~> 6.7.1'

# for money handling
gem 'monetize'

# error reporting
gem 'sentry-ruby'
gem 'sentry-rails'

# for language processing
gem 'ruby-openai'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]

  # testing
  gem 'rspec-rails', '~> 5.0'

  # test fixtures
  gem 'factory_bot_rails'

  # for ENV var management
  gem 'dotenv-rails'

  # debugging
  gem 'pry'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'faker'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'timecop'
end
