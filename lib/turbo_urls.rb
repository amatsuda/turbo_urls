require "turbo_urls/version"
require 'turbo_urls/cache'
require 'turbo_urls/railtie'

module TurboUrls
  module Interceptor
    CACHE_LOOKUP = ->(*args) do
      params = args.map(&:to_param)

      cached = TurboUrls.cache[__method__, params]
      return cached if cached

      url = super(*args)

      TurboUrls.cache[__method__, params] = url
    end
  end

  @cache = Cache.new
  def self.cache() @cache end

  def self.i_m_your_turbo_lover!
    mod = Rails.application.routes.named_routes.path_helpers_module
    mod.prepend TurboUrls::Interceptor

    (mod.public_instance_methods - Module.instance_methods).each do |meth|
      TurboUrls::Interceptor.module_eval do
        define_method meth, TurboUrls::Interceptor::CACHE_LOOKUP
      end
    end

    def mod.method_added(meth)
      TurboUrls::Interceptor.module_eval do
        define_method meth, TurboUrls::Interceptor::CACHE_LOOKUP
      end
    end
  end
end
