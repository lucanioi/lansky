Sentry.init do |config|
  config.dsn = 'https://d6b9a46bed234f35aa0219e88b78d00a@o4506039587110912.ingest.sentry.io/4506346260267008'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
