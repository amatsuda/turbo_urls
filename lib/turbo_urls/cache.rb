# frozen_string_literal: true
module TurboUrls
  class Cache
    PARAMS_PLACEHOLDER = '<<TO_PARAM>>'.freeze
    SIMPLE_CACHE_THREASHOLD = 100

    def initialize
      @simple_cache, @pattern_cache, @excluded_keys = {}, {}, []
    end

    def [](key, args)
      return if @excluded_keys.include? key

      if (pattern = @pattern_cache[key])
        args.inject(pattern) {|result, a| result.sub PARAMS_PLACEHOLDER, a }
      else
        @simple_cache[key] && @simple_cache[key][args]
      end
    end

    def []=(key, args, value)
      if args.empty?
        @pattern_cache[key] = value
      elsif @simple_cache[key] && (@simple_cache[key].length >= SIMPLE_CACHE_THREASHOLD)
        if (pattern = patternize(@simple_cache[key]))
          @pattern_cache[key] = pattern
          @simple_cache.delete key
        else
          @excluded_keys << key
        end
      else
        (@simple_cache[key] ||= {})[args] = value
      end
    end

    def clear
      @simple_cache.clear
      @pattern_cache.clear
      @excluded_keys.clear
    end

    def inspect
      {simple: @simple_cache.keys, pattern: @pattern_cache, excluded: @excluded_keys}
    end

    private def patternize(hash)
      values = hash.values.map {|v| v.split '/' }
      return if values.map(&:length).uniq.length >= 2

      pattern = []
      values.first.length.times do |i|
        if (elements = values.map {|v| v[i] }.uniq).length == 1
          pattern << elements.first
        elsif elements.map {|e| Array e} == hash.keys
          pattern << PARAMS_PLACEHOLDER
        end
      end
      pattern.join '/'
    end
  end
end
