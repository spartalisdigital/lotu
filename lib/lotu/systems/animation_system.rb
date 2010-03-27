module Lotu
  class AnimationSystem < System

    def initialize(user, opts={})
      super
      @user.extend(UserMethods)
    end

    def animated?
      defined?(@length)
    end

    def play_animation(name, opts={})
      default_opts = {
        :fps => 30
      }
      opts = default_opts.merge!(opts)
      @name = name
      @length = $lotu.animation(@name).length
      @time_per_frame = 1.0/opts[:fps]
      @current_frame = 0
      @accum_time = 0
      @user.set_gosu_image($lotu.animation(@name)[0], opts)
    end

    def update
      if animated?
        @accum_time += dt
        if @accum_time >= @time_per_frame
          frames = @accum_time/@time_per_frame
          @current_frame += frames
          @accum_time -= @time_per_frame * frames
          @current_frame = 0 if @current_frame >= @length
          image = $lotu.animation(@name)[@current_frame]
          @user.image = image
        end
      end
    end

    def to_s
      ["Name: #{@name}",
       "Current frame: #{@current_frame}",
       "Accumulated time: #{format('%.2f', @accum_time)}",
       "Time per frame: #{format('%.2f', @time_per_frame)}",
       "Length: #{@length}"]
    end

    module UserMethods
      def play_animation(name, opts={})
        @systems[AnimationSystem].play_animation(name, opts)
      end
    end

  end
end
