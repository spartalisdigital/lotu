module Lotu
  class FpsSystem
    attr_reader :fps

    def initialize(user, opts={})
      default_opts = {
        :samples => 10
      }
      opts = default_opts.merge!(opts)
      @accum = 0.0
      @ticks = 0
      @fps = 0.0
      @samples = opts[:samples]
      @objs = @actors = @input_controllers = 0
    end

    def update
      @ticks += 1
      @accum += $window.dt
      if @ticks >= @samples
        @fps = @ticks/@accum
        @ticks = 0
        @accum = 0.0
        @objs = ObjectSpace.each_object.count
        @actors = ObjectSpace.each_object(Lotu::Actor).count
        @inputs = ObjectSpace.each_object(Lotu::InputController).count
      end
    end

    def draw; end

    def to_s
      "@samples(#{@samples}) @fps(#{format("%.2f",@fps)}) @objs(#{@objs}) @actors(#{@actors}) @inputs(#{@inputs})"
    end
  end
end
