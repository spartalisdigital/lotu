#!/usr/bin/env ruby

# lotu's cursors
# Here you will learn about:
# * The Cursor class included in lotu
# * How to register events
# * How to use the systems provided by lotu

LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu
include Lotu

# Create a class for displaying something on screen
class Lobo < Actor
  def initialize( opts={} )
    super
    set_image 'lobo_tuerto.png', :width => 100
  end

  # Define a method for teleporting our instances around
  def teleport( x, y )
    @x, @y = x, y
  end
end

class Cursors < Game
  #use StalkerSystem, :stalk => [Actor, Cursor, TextBox, Lobo, Object]

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media/images'
    end
  end

  # Setup some input handling for our Cursors app
  def setup_input
    set_keys(KbEscape => :close,
             KbF1 => [:toggle_text, false],
             KbF2 => [:debug!, false],
             KbF3 => [:pause!, false])
  end

  # Now onto define some events
  def setup_events
    # When the left mouse button is clicked (as defined below in
    # setup_actors) call the teleport method in @lobo
    @cursor1.on(:click) do |x,y|
      @lobo.teleport(x,y)
    end
    # When the space bar is pressed (see below in setup_actors) call
    # the teleport method in @lobo
    @cursor2.on(:click) do |x,y|
      @lobo.teleport(x,y)
    end
  end

  def setup_actors
    # Create a portrait to teleport around with "clicks"
    @lobo = Lobo.new(:x => width/2, :y => height/2)

    # The cursor class defines a method named (you guessed) "click",
    # when this method is called, it fires an event named (again)
    # "click", that's why we attached some code to that event in
    # setup_events
    @cursor1 = Cursor.new(:image => 'crosshair-1.png',
                          :keys => {MsLeft => [:click, false]},
                          :width => 100,
                          :rand_color => true,
                          :mode => :additive)
    # Use the interpolation system to change our angle over time,
    # with an initial value of 0 degrees, up to 359 degrees (full
    # circle), do it in a time frame of 10 seconds, and when done,
    # start over again
    @cursor1.interpolate_angle(:init => 0, :end => 359, :duration => 10, :start_in => 3, :bounce => true, :loop => true)

    @cursor2 = Cursor.new(:image => 'crosshair-2.png',
                          :use_mouse => false,
                          :keys => {
                            KbSpace => [:click, false],
                            KbUp => :up,
                            KbDown => :down,
                            KbLeft => :left,
                            KbRight => :right},
                          :width => 100,
                          :rand_color => true,
                          :mode => :additive)
    # Use the transformation system to change our angle over time,
    # with an initial value of 359 degrees, up to 0 degrees (full
    # circle in reverse), do it in a time frame of 1 second, and
    # when done, start over again
    @cursor2.interpolate_angle(:init => 359, :end => 0, :duration => 1, :loop => true, :start_in => 2)

    # Center @cursor2 vertically and move it to the right 3/4 of the
    # screen
    @cursor2.x = width*3/4
    @cursor2.y = height/2

    # Here we tell the TextBox to watch some objects, the TextBox will
    # call the to_s method on the objects it's watching
    # Create a TextBox with default option :size => 15
    @info = TextBox.new(:size => 15)
    @info.text("Press F1 to hide this text", :size => 24)
    # Watch the FPS, so we get a nice FPS report on the screen
    @info.watch(lambda{ "FPS: #{ fps }" }, :size => 20)
    # Watch the Stalker system, so we know how many objects of the
    # classes we specified up in "use StalkerSystem" are around
    @info.watch( @systems[StalkerSystem], :color => 0xff3ffccf )
    # We can change the size for a specific line of text
    @info.text("@cursor1 data:", :size => 20)
    @info.text("move with Mouse | click with LeftMouseButton")
    # And color
    @info.watch(@cursor1, :color => @cursor1.color)

    # Lets watch @cursor2 too
    @info.text("@cursor2 data:", :size => 20)
    @info.text("move with Arrow keys | click with Space")
    @info.watch(@cursor2, :color => @cursor2.color)
    @info.text("click to teleport the portrait!")
  end

  def toggle_text
    @info.toggle!
  end

end

# Create and start the game loop by showing the app
Cursors.new.show
