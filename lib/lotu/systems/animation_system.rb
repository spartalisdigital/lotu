module Lotu
  class AnimationSystem < System

    def initialize(user, opts={})
      super
    end

    def animated?
      defined?(@length)
    end

    def play_animation(name, speed)
      @name = name
      @length = $lotu.animations[@name].length
      @time_per_frame = 1000.0/speed
      @current_frame = 0
      @accum_time = 0
    end

    def update
      if animated?
        @accum_time += dt
        if @accum_time >= @time_per_frame
          @current_frame += 1
          @accum_time -= @time_per_frame
          @current_frame = 0 if @current_frame >= @length
        end
      end
    end

    def draw
      @user.image = $lotu.animations[@name][@current_frame] if animated?
    end

    module UserMethods
      def play_animation(name, speed)
        @systems[AnimationSystem].play_animation(name, speed)
      end
    end

  end
end
