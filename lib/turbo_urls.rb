require "turbo_urls/version"

module TurboUrls
  module Interceptor; end
  @cache = {}
  def self.cache() @cache end

  def self.i_m_your_turbo_lover!
    [Rails.application.routes.named_routes.path_helpers_module, Rails.application.routes.named_routes.url_helpers_module].each do |mod|
      mod.prepend TurboUrls::Interceptor
      def mod.method_added(meth)
        TurboUrls::Interceptor.module_eval do
          define_method meth, TurboUrls::CACHE_IF_NO_ARGUMENT
        end
      end
    end
  end

  CACHE_IF_NO_ARGUMENT = ->(*args) do
    return super(*args) if args.any?

    cached = TurboUrls.cache[__method__]
    return cached if cached

    url = super(*args)

    TurboUrls.cache[__method__] = url
  end
end
