require "turbo_urls/version"
require 'turbo_urls/cache'
require 'turbo_urls/railtie'

module TurboUrls
  module Interceptor; end
  @cache = Cache.new
  def self.cache() @cache end

  def self.i_m_your_turbo_lover!
    [Rails.application.routes.named_routes.path_helpers_module, Rails.application.routes.named_routes.url_helpers_module].each do |mod|
      mod.prepend TurboUrls::Interceptor
      def mod.method_added(meth)
        TurboUrls::Interceptor.module_eval do
          define_method meth, TurboUrls::CACHE_METHOD_BODY
        end
      end
    end
  end

  CACHE_METHOD_BODY = ->(*args) do
    return super(*args) unless args.empty? || args.all? {|a| a.is_a?(Fixnum) || a.is_a?(String) }

    cached = TurboUrls.cache[__method__, args]
    return cached if cached

    url = super(*args)

    TurboUrls.cache[__method__, args] = url
  end
end
