require 'test_helper'

class TurboUrlsTest < ActionDispatch::IntegrationTest
  teardown do
    TurboUrls.cache.clear
  end

  test 'when calling one url_for' do
    visit '/one'
    assert_equal({[:conferences_path, []] => '/conferences'}, TurboUrls.cache)
  end

  test 'calling url_for taking an integer parameter' do
    visit '/integer_show'
    assert_equal({[:conference_path, [1]] => '/conferences/1'}, TurboUrls.cache)
  end

  test 'calling url_for taking a string parameter' do
    visit '/string_show'
    assert_equal({[:conference_path, ['2']] => '/conferences/2'}, TurboUrls.cache)
  end
end
