module TurboUrls
  class Cache
    def initialize
      @cache = {}
    end

    def [](key, args)
      @cache[[key, args]]
    end

    def []=(key, args, value)
      @cache[[key, args]] = value
    end

    def clear
      @cache.clear
    end
  end
end
