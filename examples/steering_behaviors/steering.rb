#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

class SteeringRuby < Actor
  def initialize(opts={})
    super
    use(SteeringSystem, opts)
  end

  def warp(x, y)
    @pos.x, @pos.y = x, y
  end
end

class Example < Game
  def initialize
    # This will call the hooks:
    # load_resources, setup_systems and setup_actors
    # declared in the parent class
    super
    # Custom setup methods for this class
    setup_events
  end

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media/images'
      load_animations '../media/animations'
    end
  end

  def setup_input
    set_keys(KbEscape => :close,
             MsRight => :reset_ruby,
             KbD => [:debug!, false])
  end

  def setup_systems
    # It's important to call super here to setup the InputSystem
    super
    use(FpsSystem)
    use(StalkerSystem, :stalk => [Actor, Vector2d, Object])
  end

  def setup_actors
    @ruby = SteeringRuby.new(:mass => 0.3, :max_speed => 100, :max_turn_rate => 140)
    @ruby.warp(width/2, height/2)
    @ruby.activate(:evade)
    @ruby.play_animation('missile.png')

    @ruby2 = SteeringRuby.new
    @ruby2.activate(:pursuit)
    @ruby2.play_animation('missile.png', :factor_x => 0.5, :factor_y => 0.5, :fps => 60)

    @cursor = Cursor.new(:image => 'crosshair-1.png',
                         :keys => {MsLeft => [:click, false]})

    @window_info = TextBox.new(:size => 15)
    @window_info.watch(@systems[FpsSystem])
    @window_info.watch(@systems[StalkerSystem])
    @window_info.watch(@cursor, :color => 0xffff0000)
    @window_info.text("Click to start the simulation")
    @window_info.text("One will pursuit while the other evades, right click to center evader on screen")

    @ruby_info = TextBox.new(:attach_to => @ruby, :size => 14)
    @ruby_info.watch(@ruby)
  end

  def setup_events
    @cursor.on(:click) do |x,y|
      @ruby.pursuer = @ruby2
      @ruby2.evader = @ruby
    end
  end

  def reset_ruby
    @ruby.pos.x = width/2
    @ruby.pos.y = height/2
  end
end

Example.new.show
