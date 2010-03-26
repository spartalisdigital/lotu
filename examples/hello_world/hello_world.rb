#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

class MovingRuby < Actor

  def initialize(opts={})
    super
    # Use the image which filename is CptnRuby Gem.png
    set_image 'CptnRuby Gem.png'
    # Map keys to some methods
    set_keys(KbRight => :move_right,
             KbLeft => :move_left,
             KbUp => :move_up,
             KbDown => :move_down)
  end

  # Let's define some basic movement methods
  def move_right
    @x += 1
  end

  def move_left
    @x -= 1
  end

  def move_up
    @y -= 1
  end

  def move_down
    @y += 1
  end

end

class Example < Game

  def initialize
    # This will call the hooks:
    # load_resources, setup_systems and setup_actors
    # declared in the parent class
    super
    # When the Escape key is pressed, call the close method on class Example
    set_keys(KbEscape => :close)
  end

  def load_resources
    # From this file,
    with_path_from_file(__FILE__) do
      # go back one dir and search inside media/
      load_images '../media/'
    end
  end

  def setup_actors
    # Create a ruby in the middle of the screen
    @ruby = MovingRuby.new(:x => width/2, :y => height/2)
    # Create a TextBox so we can display a message on screen
    @info = TextBox.new
    @info.text("Move around with arrow keys")
  end

end

Example.new.show
