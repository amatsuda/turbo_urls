require "turbo_urls/version"
require 'turbo_urls/cache'
require 'turbo_urls/railtie'

module TurboUrls
  module Interceptor
    CACHE_LOOKUP = ->(*args) do
      if args.empty? || args.all? {|a| a.is_a?(Fixnum) || a.is_a?(String) }
        # do nothing
      elsif defined?(ActiveRecord::Base) && args.any? {|a| a.is_a? ActiveRecord::Base }
        args = args.map {|a| a.is_a?(ActiveRecord::Base) ? a.to_param : a }
      else
        return super(*args)
      end

      cached = TurboUrls.cache[__method__, args]
      return cached if cached

      url = super(*args)

      TurboUrls.cache[__method__, args] = url
    end
  end

  @cache = Cache.new
  def self.cache() @cache end

  def self.i_m_your_turbo_lover!
    mod = Rails.application.routes.named_routes.path_helpers_module
    mod.prepend TurboUrls::Interceptor
    def mod.method_added(meth)
      TurboUrls::Interceptor.module_eval do
        define_method meth, TurboUrls::Interceptor::CACHE_LOOKUP
      end
    end
  end
end
