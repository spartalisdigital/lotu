module Lotu
  class StalkerSystem

    def initialize(user, opts={})
      default_opts = {
        :stalk => [Actor]
      }
      opts = default_opts.merge!(opts)
      @stalked = {}
      opts[:stalk].each do |type|
        @stalked[type] = 0
      end
    end

    def update
      @stalked.each_key do |type|
        @stalked[type] = ObjectSpace.each_object(type).count
      end
    end

    def to_s
      @stalked.map do |type, count|
        "#{type}: #{count}"
      end
    end

    def draw;end

  end
end
