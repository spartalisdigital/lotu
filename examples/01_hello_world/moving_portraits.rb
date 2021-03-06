#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Hello world for lotu
# Here you will learn about:
# * Loading image resources
# * Binding keys to window and actors
# * How to display text on screen using a text box


LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu
include Lotu

# We want to move something around the screen so we create a new Actor
# subclass, set the image for all the instances of that class and
# define the movement methods
class Portrait < Actor
  def initialize( opts )
    # It's important to call super so we take advantage of automatic
    # management for this object (being added to draw and update queues)
    super
    # Use the image which filename is "lobo_tuerto.png", and scale
    # it's size to half width and half height
    set_image 'lobo_tuerto.png', :factor_x => 0.5, :factor_y => 0.5
  end

  # Let's define some basic movement methods
  def move_right; @x += 1 end
  def move_left;  @x -= 1 end
  def move_up;    @y -= 1 end
  def move_down;  @y += 1 end
end

# Let's subclass the Game class and write some code!
class MyPortraits < Game

  def initialize
    # This will call the hooks:
    # load_resources, setup_actors, setup_input and setup_events
    # declared in the parent class
    super
    # When the Escape key is pressed, call the close method on our
    # game instance MyPortraits, when D key is pressed turn on
    # debug, we pass false into the array to tell the input system we
    # don't want autofire on, else pass the number of milliseconds
    # (zero and no array is the same)
    set_keys(KbEscape => :close,
             KbD => [:debug!, false])
  end

  # This method is called when we call super inside initialize
  def load_resources
    # From this file,
    with_path_from_file(__FILE__) do
      # go back one dir and search inside media/images
      load_images '../media/images'
    end
  end

  # This method is called when we call super inside initialize
  def setup_actors
    # Create a portrait in the middle of the screen
    @lobo1 = Portrait.new(:x => width/2, :y => height/2)
    # Map keys to some methods
    @lobo1.set_keys(KbRight => :move_right,
                    KbLeft => :move_left,
                    KbUp => :move_up,
                    KbDown => :move_down)

    # Rinse and repeat... but invert some keys
    @lobo2 = Portrait.new(:x => width/2, :y => height/2)
    @lobo2.set_keys(KbRight => :move_left,
                    KbLeft => :move_right,
                    KbUp => :move_up,
                    KbDown => :move_down)

    # Create a TextBox so we can display a message on screen
    @info = TextBox.new

    # Add some text
    @info.text("Hello world!")
    @info.watch lambda{ "FPS: #{ fps }" }

    # Add more text, but specify the color and size in pixels
    @info.text("Move the portraits around with arrow keys", :size => 16, :color => 0xff33ccff)
  end

end

# Create and show the app
MyPortraits.new.show
