#!/usr/bin/env ruby

# Here you will learn about:
# * The steering system pursuit, and evade_multiple behaviors
# * How to play animations
# * How to attach a text box to an actor

LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu
include Lotu

# Let's define a Missile class that will use a Steering system to
# control it's movement
class Missile < Actor
  def initialize(opts={})
    super
    # Activate the steering system and pass the opts, since they might
    # have some config info for the system
    use(SteeringSystem, opts)
  end

  def teleport(x, y)
    @pos.x, @pos.y = x, y
  end
end

# The main app class
class EvadeMultiple < Game
  def initialize
    # This will call the hooks:
    # load_resources, setup_systems, setup_input and setup_actors
    # declared in the parent class
    super
    # Custom setup methods for this class
    setup_events
  end

  # Let's load some images and animations, check out the animations
  # directory, the animation there was created with:
  # {Sprite Sheet Packer}[http://spritesheetpacker.codeplex.com/]
  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media/images'
      load_animations '../media/animations'
    end
  end

  def setup_input
    set_keys(KbEscape => :close,
             MsRight => :teleport_big_missile_to_midscreen,
             KbF2 => [:debug!, false],
             KbF1 => [:toggle_info, false],
             KbSpace => [:pause!, false])
  end

  def setup_systems
    # It's important to call super here to setup the InputSystem
    super
    use(FpsSystem)
    use(StalkerSystem, :stalk => [Actor, Missile, Vector2d, Object])
  end

  def setup_actors
    @big_missile = Missile.new(:mass => 0.3, :max_speed => 100, :max_turn_rate => 140)
    @big_missile.teleport(width/2, height/2)
    @big_missile.activate(:evade_multiple)
    @big_missile.play_animation('missile.png')

    @little_missiles = []
    5.times do |i|
      @little_missiles << Missile.new(:x => 200 - rand(400), :y => 200 - rand(400), :rand_color => true)
      @little_missiles[i].activate(:pursuit)
      @little_missiles[i].play_animation('missile.png', :fps => 60+rand(60), :height => 10+rand(30))
    end

    @cursor = Cursor.new(:image => 'crosshair-3.png',
                         :keys => {MsLeft => [:click, false]},
                         :rand_color => true)

    @window_info = TextBox.new(:size => 15)
    @window_info.text("Press F1 to hide this text", :size => 24)
    @window_info.watch(@systems[FpsSystem], :size => 20)
    @window_info.watch(@systems[StalkerSystem], :color => 0xff33ccff)
    @window_info.watch(@cursor, :color => @cursor.color)
    @window_info.text("Click to start the simulation", :color => 0xffffff00)
    @window_info.text("Little missiles will pursuit while the big one evades, right click to center big one on screen")

    @missile_info = TextBox.new(:attach_to => @big_missile, :size => 14)
    @missile_info.watch(@big_missile)
  end

  def setup_events
    @cursor.on(:click) do |x,y|
      @big_missile.pursuers = @little_missiles
      @little_missiles.each do |lil_missile|
        lil_missile.evader = @big_missile
      end
    end
  end

  def teleport_big_missile_to_midscreen
    @big_missile.pos.x = width/2
    @big_missile.pos.y = height/2
  end

  def toggle_info
    @missile_info.toggle!
    @window_info.toggle!
  end

end

# Create and start the application
EvadeMultiple.new.show
