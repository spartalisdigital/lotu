class FpsCounter
  attr_reader :fps
  
  def initialize(samples = 10)
    @accum = 0.0
    @ticks = 0
    @fps = 0.0
    @samples = samples

    @objs = @actors = @input_controllers = @lotu = 0
  end

  def update(elapsed_t)
    @ticks += 1
    @accum += elapsed_t
    if @ticks >= @samples
      @fps = 1000/(@accum/@ticks)
      @ticks = 0
      @accum = 0.0
      @objs = ObjectSpace.each_object.count
      @actors = ObjectSpace.each_object(Lotu::Actor).count
      @inputs = ObjectSpace.each_object(Lotu::InputController).count
    end
  end

  def to_s
    "Samples: #{@samples} FPS: #{format("%.2f",@fps)} Objs: #{@objs} Acts: #{@actors} InputsCs: #{@inputs}"
  end
end
