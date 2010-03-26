module Lotu
  class FpsSystem

    def initialize(user, opts={})
      default_opts = {
        :samples => 10
      }
      opts = default_opts.merge!(opts)
      @accum = 0.0
      @ticks = 0
      @fps = 0.0
      @samples = opts[:samples]
    end

    def update
      @ticks += 1
      @accum += $lotu.dt
      if @ticks >= @samples
        @fps = @ticks/@accum
        @ticks = 0
        @accum = 0.0
      end
    end

    def to_s
      "Samples: #{@samples} | FPS: #{format("%.2f",@fps)}"
    end

    def draw;end

  end
end
