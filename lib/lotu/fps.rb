class FpsCounter
  attr_reader :fps
  
  def initialize(samples = 10)
    @accum = 0.0
    @ticks = 0
    @fps = 0.0
    @samples = samples
  end

  def update(elapsed_t)
    @ticks += 1
    @accum += elapsed_t
    if @ticks >= @samples
      @fps = 1000/(@accum/@ticks)
      @ticks = 0
      @accum = 0.0
    end
  end

  def to_s
    "Samples: #{@samples} FPS: #{format("%.2f",@fps)}"
  end
end
