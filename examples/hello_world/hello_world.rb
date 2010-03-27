#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

class MovingRuby < Actor

  def initialize(opts={})
    super
    # Use the image which filename is CptnRuby Gem.png
    set_image 'lobo_tuerto.png', :factor_x => 0.5, :factor_y => 0.5
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
    set_keys(KbEscape => :close,
             KbD => [:debug!, false])
  end

  def load_resources
    # From this file,
    with_path_from_file(__FILE__) do
      # go back one dir and search inside media/
      load_images '../media/images'
    end
  end

  def setup_actors
    # Create a ruby in the middle of the screen
    @ruby = MovingRuby.new(:x => width/2, :y => height/2)
    # Map keys to some methods
    @ruby.set_keys(KbRight => :move_right,
                   KbLeft => :move_left,
                   KbUp => :move_up,
                   KbDown => :move_down)
    @ruby2 = MovingRuby.new(:x => width/2, :y => height/2)
    # Map keys to some methods
    @ruby2.set_keys(KbRight => :move_left,
                    KbLeft => :move_right,
                    KbUp => :move_up,
                    KbDown => :move_down)
    # Create a TextBox so we can display a message on screen
    @info = TextBox.new
    @info.text("Hello world!")
    @info.text("Move around with arrow keys", :size => 16, :color => 0xff33ccff)
  end

end

Example.new.show
