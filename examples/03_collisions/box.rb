#!/usr/bin/env ruby

LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Lotu
include Gosu

class Painting < Actor
  # available collision shapes include :circle and :box
  # if no :shape is specified, :circle is assumed
  collides_as :canvas, :shape => :box

  def initialize( opts )
    # It's important to call super so we take advantage of automatic
    # management for this object (being added to draw and update queues)
    super
    # Use the image which filename is "lobo_tuerto.png", and scale
    # it's size to half width and half height
    set_image 'lobo_tuerto.png', :factor_x => 0.5, :factor_y => 0.5
  end

  # if you want to try the :shape => :circle thing
  # you are going to need a function that specifies
  # the collision radius called:

  def collision_radius
    @width / 2.0 * @factor_x
  end

  # Let's define some basic movement methods
  def move_right; @x += 1 end
  def move_left;  @x -= 1 end
  def move_up;    @y -= 1 end
  def move_down;  @y += 1 end
end

class Example < Game
  use_systems :collision

  def initialize
    super
    set_keys(KbEscape => :close, KbD => [:debug!, false])
  end

  # This method is called when we call super inside initialize
  def load_resources
    # From this file,
    with_path_from_file(__FILE__) do
      # go back one dir and search inside media/images
      load_images '../media/images'
    end
  end

  def setup_events
    when_colliding( :canvas, :canvas ) do |b1, b2|
      b1.color = Gosu::Color.from_hsv(rand(360), 1, 1)
      b2.color = Gosu::Color.from_hsv(rand(360), 1, 1)
    end
  end

  # This method is called when we call super inside initialize
  def setup_actors
    # Create a portrait in the middle of the screen
    @lobo1 = Painting.new(:x => width/2 - 100, :y => height/2)
    # Map keys to some methods
    @lobo1.set_keys(KbRight => :move_right,
                    KbLeft => :move_left,
                    KbUp => :move_up,
                    KbDown => :move_down)

    # Rinse and repeat... but invert some keys
    @lobo2 = Painting.new(:x => width/2 + 100, :y => height/2)
    @lobo2.set_keys(KbRight => :move_left,
                    KbLeft => :move_right,
                    KbUp => :move_down,
                    KbDown => :move_up)

    # Create a TextBox so we can display a message on screen
    @info = TextBox.new

    # Add some text
    @info.text("Hello world!")
    @info.watch lambda{ "FPS: #{ fps }" }

    # Add more text, but specify the color and size in pixels
    @info.text("Move the portraits around with arrow keys", :size => 16, :color => 0xff33ccff)
  end
end

Example.new.show
