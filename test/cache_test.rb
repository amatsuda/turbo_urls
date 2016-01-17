require 'test_helper'

class CacheTest < ActiveSupport::TestCase
  test 'Cache' do
    begin
      threashold_was = TurboUrls::Cache::SIMPLE_CACHE_THREASHOLD
      suppress_warnings { TurboUrls::Cache::SIMPLE_CACHE_THREASHOLD = 3 }

      app = ActionDispatch::Integration::Session.new(Rails.application)
      app.extend(Rails.application.routes.url_helpers)
      app.extend(Rails.application.routes.mounted_helpers)

      assert_nil TurboUrls.cache[:conferences_path, []]
      app.conferences_path
      assert_equal '/conferences', TurboUrls.cache[:conferences_path, []]

      app.conference_path(1)
      app.conference_path(2)
      app.conference_path(3)
      assert_nil TurboUrls.cache[:conference_path, ['5']]

      app.conference_path(4)
      assert_equal '/conferences/5', TurboUrls.cache[:conference_path, ['5']]

    ensure
      suppress_warnings { TurboUrls::Cache::SIMPLE_CACHE_THREASHOLD = threashold_was }
    end
  end
end
