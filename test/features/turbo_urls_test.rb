require 'test_helper'

class TurboUrlsTest < ActionDispatch::IntegrationTest
  teardown do
    TurboUrls.cache.clear
  end

  test 'when not calling any url_for' do
    visit '/null'
    assert_empty TurboUrls.cache
  end

  test 'when calling one url_for' do
    visit '/one'
    assert_equal({conferences_path: '/conferences'}, TurboUrls.cache)
  end
end
