VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  # Rspec will generate cassete folders and files based on specs description.
  # Add a :vcr tag on a spec context enable it.
  c.configure_rspec_metadata!

  ###########################################
  # filter out API keys from VCR recordings #
  ###########################################

  # keep api keys out of recordings. we find names from what's in the environment,
  # but also (since CI probably doesn't have all (or any) of those configured) from
  # .env.default, which defines the things that a live environment is expected to
  # see, and which therefore is useful in predicting what our specs will be working with
  env_var_names_to_filter = ENV.keys.select { |key| key.ends_with?('_KEY') }
  env_var_names_to_filter += File.read(Rails.root.join('.env')).scan(/^\w+_KEY(?=)/m)

  env_var_names_to_filter.uniq.each do |key|
    # keeping this lookup dynamic to allow ENV to change across tests
    c.filter_sensitive_data("<FILTERED_#{key}>") { ENV[key] }
  end

  ###############################
  # OVERRIDE VCR RECORDING MODE #
  ###############################
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
