#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class Cursor < Lotu::Cursor
  is_eventful
  is_controllable
  is_drawable

  def initialize
    super
    set_keys(MsLeft => [:click, false],
             KbSpace => [:click, false],
             KbUp => :up,
             KbDown => :down,
             KbLeft => :left,
             KbRight => :right)
  end
end

class Player < Lotu::Actor
  is_drawable
  is_controllable

  attr_reader :speed

  def initialize
    super
    set_image 'CptnRuby Gem.png'
    set_keys(KbRight => :move_right,
             KbLeft => :move_left,
             KbUp => :move_up,
             KbDown => :move_down)
  end

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

  def warp(x, y)
    @x, @y = x, y
  end
end

class Example < Lotu::Window
  is_controllable
  is_resourceful

  def initialize
    super
    set_keys KbEscape => :close
    with_path __FILE__ do
      load_images '../media'
      load_sounds '../media'
    end

    @player = Player.new
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @cursor = Cursor.new
    @cursor.set_image('crosshair.png')
    @cursor.on(:click) do |x,y|
      @player.warp(x,y)
    end
  end

  def draw
    super
    @fps_counter.draw
    @font.draw("Clicked on? #{@cursor.clicked_x}, #{@cursor.clicked_y}", 10, 30, 0, 1.0, 1.0, 0xfffff000)
  end
end

Example.new.show
