module Lotu
  class StalkerSystem < BaseSystem

    def initialize(user, opts={})
      super
      default_opts = {
        :stalk => [Actor],
        :ticks_per_update => 30
      }
      opts = default_opts.merge!(opts)
      @ticks = 0
      @ticks_per_update = opts[:ticks_per_update]
      @stalked = {}
      opts[:stalk].each do |type|
        @stalked[type] = 0
      end
    end

    def update
      @ticks += 1
      if @ticks >= @ticks_per_update
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

  end
end
