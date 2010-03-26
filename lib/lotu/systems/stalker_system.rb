module Lotu
  class StalkerSystem

    def initialize(user, opts={})
      default_opts = {
        :stalk => [Actor],
        :samples => 10
      }
      opts = default_opts.merge!(opts)
      @ticks = 0
      @samples = opts[:samples]
      @stalked = {}
      opts[:stalk].each do |type|
        @stalked[type] = 0
      end
    end

    def update
      @ticks += 1
      if @ticks >= @samples
        @stalked.each_key do |type|
          @stalked[type] = ObjectSpace.each_object(type).count
        end
        @ticks = 0
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
