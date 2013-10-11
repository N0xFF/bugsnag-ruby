module Bugsnag
  class Sidekiq
    def call(worker, msg, queue)
      begin
        yield
      rescue => ex
        Bugsnag.auto_notify(ex, {:context => "sidekiq##{queue}", :sidekiq => msg})
        raise
      ensure
        Bugsnag.clear_request_data
      end
    end
  end
end

::Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add ::Bugsnag::Sidekiq
  end
end