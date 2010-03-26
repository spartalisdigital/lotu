#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

class SteeringRuby < Actor
  def initialize(opts={})
    super
    set_image 'CptnRuby Gem.png'
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
    setup_input
    setup_events
  end

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media'
    end
  end

  def setup_input
    set_keys(KbEscape => :close,
             MsRight => :reset_ruby)
  end

  def setup_systems
    super
    use(FpsSystem)
  end

  def setup_actors
    @ruby = SteeringRuby.new(:mass => 0.3, :max_speed => 100, :max_turn_rate => 140)
    @ruby.warp(width/2, height/2)
    @ruby.activate(:evade)

    @ruby2 = SteeringRuby.new
    @ruby2.activate(:pursuit)

    @cursor = Cursor.new(:image => 'crosshair.png',
                         :keys => {MsLeft => [:click, false]})

    @window_info = TextBox.new(:size => 15)
    @window_info.watch(@systems[FpsSystem])
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
