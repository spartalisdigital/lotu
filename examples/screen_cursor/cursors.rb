#!/usr/bin/env ruby

# lotu's cursors
# Here you will learn about:
# * The Cursor class included in lotu
# * How to register events
# * How to use the systems provided by lotu

LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

# Create a class for displaying something on screen
class Lobo < Actor
  def initialize(opts={})
    super
    set_image 'lobo_tuerto.png', :factor_x => 0.3, :factor_y => 0.3
  end

  # Define a method for teleporting our instances around
  def teleport(x, y)
    @x, @y = x, y
  end
end

class Cursors < Game
  def initialize
    # This will call the hooks:
    # load_resources, setup_systems, setup_input and setup_actors
    # declared in the parent class
    super
    # Custom setup methods for this class
    setup_events
  end

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media/images'
    end
  end

  def setup_systems
    # It's important to call super here to setup the InputSystem in
    # the parent class
    super
    # To use the systems lotu provides, you just "use" them
    # Let's activate the FPS system, so we can track the frames per
    #second our app is pushing out
    use(FpsSystem)
    # Activate the stalker system to track how many objects of these
    # classes are around
    use(StalkerSystem, :stalk => [Actor, Cursor, TextBox, Lobo, Object])
  end

  # Setup some input handling for our Cursors app
  def setup_input
    set_keys(KbEscape => :close,
             KbD => [:debug!, false])
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
                          :color => 0xff0099ff,
                          :width => 100,
                          :height => 100)

    @cursor2 = Cursor.new(:image => 'crosshair-2.png',
                          :use_mouse => false,
                          :keys => {
                            KbSpace => [:click, false],
                            KbUp => :up,
                            KbDown => :down,
                            KbLeft => :left,
                            KbRight => :right},
                          :color => 0xff99ff00,
                          :factor_x => 0.5,
                          :factor_y => 0.5)

    # Center @cursor2 vertically and move it to the right 3/4 of the
    # screen
    @cursor2.x = width*3/4
    @cursor2.y = height/2

    # Here we tell the TextBox to watch some objects, the TextBox will
    # call the to_s method on the objects it's watching
    # Create a TextBox with default option :size => 15
    @info = TextBox.new(:size => 15)
    # Watch the FPS, so we get a nice FPS report on the screen
    @info.watch(@systems[FpsSystem])
    # Watch the Stalker system, so we know how many objects of the
    # classes we specified up in setup_systems are around
    @info.watch(@systems[StalkerSystem], :color => 0xff3ffccf)
    # We can change the size for a specific line of text
    @info.text("@cursor1 data:", :size => 20)
    # And color
    @info.watch(@cursor1, :color => 0xff0099ff)
    @info.text("@cursor2 data:", :size => 20)
    @info.watch(@cursor2, :color => 0xff99ff00)
    @info.text("Use the mouse to move @cursor1 around, use arrow keys for @cursor2")
    @info.text("click with space and left mouse button to teleport the portrait!")
  end

end

# Create and start the game loop by showing the app
Cursors.new.show
