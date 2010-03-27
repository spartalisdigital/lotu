module Lotu
  class FpsSystem

    def initialize(user, opts={})
      default_opts = {
        :ticks_per_update => 10
      }
      opts = default_opts.merge!(opts)
      @accum = 0.0
      @ticks = 0
      @fps = 0.0
      @ticks_per_update = opts[:ticks_per_update]
    end

    def update
      @ticks += 1
      @accum += $lotu.dt
      if @ticks >= @ticks_per_update
        @fps = @ticks/@accum
        @ticks = 0
        @accum = 0.0
      end
    end

    def to_s
      "Ticks per update: #{@ticks_per_update} | FPS: #{format("%.2f",@fps)}"
    end

    def draw;end

  end
end
