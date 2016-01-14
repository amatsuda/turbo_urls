require 'test_helper'

class TurboUrlsTest < ActionDispatch::IntegrationTest
  teardown do
    TurboUrls.cache.clear
  end

  test 'when calling one url_for' do
    visit '/one'
    assert_equal('/conferences', TurboUrls.cache[:conferences_path, []])
  end

  test 'calling url_for taking an integer parameter' do
    visit '/integer_show'
    assert_equal('/conferences/1', TurboUrls.cache[:conference_path, [1]])
  end

  test 'calling url_for taking a string parameter' do
    visit '/string_show'
    assert_equal('/conferences/2', TurboUrls.cache[:conference_path, ['2']])
  end

  test 'calling model_path taking an AR model instance' do
    kaigi = Conference.create! name: 'RubyKaigi'

    visit "/model_path/#{kaigi.id}"
    assert_equal("/conferences/#{kaigi.id}", TurboUrls.cache[:conference_path, [kaigi.id.to_s]])

    Conference.delete_all
  end

  test 'calling url_for taking an AR model instance' do
    kaigi = Conference.create! name: 'RubyKaigi'

    visit "/url_for_model/#{kaigi.id}"
    assert_equal("/conferences/#{kaigi.id}", TurboUrls.cache[:conference_path, [kaigi.id.to_s]])

    Conference.delete_all
  end
end
