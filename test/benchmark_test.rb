require 'test_helper'
require 'benchmark/ips'

class BenchmarkTest < ActiveSupport::TestCase
  test 'speed is improved' do
    app = ActionDispatch::Integration::Session.new(Rails.application)
    job = Benchmark::IPS::Job.new
    job.item('cached') { app.conferences_path }
    job.run_warmup
    job.run
    turbo_ips = job.full_report.data.first[:ips]

    TurboUrls::Interceptor.module_eval { def conferences_path() super; end }

    job = Benchmark::IPS::Job.new
    job.item('original') { app.conferences_path }
    job.run_warmup
    job.run
    original_ips = job.full_report.data.first[:ips]
    assert_true original_ips < turbo_ips
  end
end
