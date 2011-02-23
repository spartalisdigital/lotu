#!/usr/bin/env ruby

# Here you will learn about:
# * The steering system
# * How to play animations
# * How to attach a text box to an actor

LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu
include Lotu

# Let's define a Missile class that will use a Steering system to
# control it's movement
class Missile < Actor
  use SteeringSystem

  def teleport(x, y)
    @pos.x, @pos.y = x, y
  end
end

# The main app class
class SteeringMissiles < Game
  use StalkerSystem, :stalk => [Actor, Missile, Vector2d, Object]

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
             KbF1 => [:toggle_missile_info, false])
  end

  def setup_actors
    @big_missile = Missile.new(:mass => 0.3, :max_speed => 100, :max_turn_rate => 140)
    @big_missile.teleport(width/2, height/2)
    @big_missile.activate(:evade)
    @big_missile.play_animation('missile.png')

    @little_missile = Missile.new
    @little_missile.activate(:pursuit)
    @little_missile.play_animation('missile.png', :fps => 60, :height => 20)

    @cursor = Cursor.new(:image => 'crosshair-3.png',
                         :keys => {MsLeft => [:click, false]},
                         :rand_color => true)

    @window_info = TextBox.new(:size => 15)
    @window_info.text("Press F1 to hide this text", :size => 24)
    @window_info.watch(lambda{ "FPS: #{fps}" }, :size => 20)
    @window_info.watch( @systems[StalkerSystem], :color => 0xff33ccff)
    @window_info.watch(@cursor, :color => @cursor.color)
    @window_info.text("Click to start the simulation", :color => 0xffffff00)
    @window_info.text("One will pursuit while the other evades, right click to center evader on screen")

    @missile_info = TextBox.new(:attach_to => @big_missile, :size => 14)
    @missile_info.watch(@big_missile)
  end

  def setup_events
    @cursor.on(:click) do |x,y|
      @big_missile.pursuer = @little_missile
      @little_missile.evader = @big_missile
    end
  end

  def teleport_big_missile_to_midscreen
    @big_missile.pos.x = width/2
    @big_missile.pos.y = height/2
  end

  def toggle_missile_info
    @missile_info.toggle!
    @window_info.toggle!
  end
end

# Create and start the application
SteeringMissiles.new.show
