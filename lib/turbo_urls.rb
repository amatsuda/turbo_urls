require "turbo_urls/version"

module TurboUrls
  @cache = {}
  def self.cache() @cache end

  CACHE_IF_NO_ARGUMENT = ->(*args) do
    return super(*args) if args.any?

    cached = TurboUrls.cache[__method__]
    return cached if cached

    url = super(*args)

    TurboUrls.cache[__method__] = url
  end
end
