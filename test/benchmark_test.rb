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

  test 'methods calls are reduced' do
    app = ActionDispatch::Integration::Session.new(Rails.application)
    app.conferences_path  # warm up

    called_methods = []
    tp = TracePoint.new(:call, :c_call) {|t| called_methods << [t.defined_class, t.method_id]}
    tp.enable
    app.conferences_path
    tp.disable
    turbo_called_methods = called_methods

    TurboUrls::Interceptor.module_eval { def conferences_path() super; end }

    called_methods = []
    tp.enable
    app.conferences_path
    tp.disable

    original_called_methods = called_methods
    assert_true turbo_called_methods.length < original_called_methods.length
  end
end
