# frozen_string_literal: true
module TurboUrls
  class Railtie < ::Rails::Railtie
    initializer 'turbo_urls' do
      config.after_initialize do
        TurboUrls.i_m_your_turbo_lover!
      end
    end
  end
end
