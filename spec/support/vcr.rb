VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  # Rspec will generate cassete folders and files based on specs description.
  # Add a :vcr tag on a spec context enable it.
  c.configure_rspec_metadata!

  # By setting the environment variable VCR=all you can force VCR to re-record
  # all your cassettes. if you do `VCR=all rspec SPECIFIC_FILE`, then it will
  # re-record for that specific file only.
  #
  # Default mode is `new_episodes`, which will record new interactions should
  # they arise. See their doc for more info:
  # https://andrewmcodes.gitbook.io/vcr/record_modes/new_episodes
  record_mode = ENV['VCR'] ? ENV['VCR'].to_sym : :new_episodes
  c.default_cassette_options = { record: record_mode }
end
