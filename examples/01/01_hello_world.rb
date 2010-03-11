#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class Player < Lotu::Actor
  attr_reader :speed
  def initialize(parent)
    super
    @speed = 100
    set_image 'CptnRuby Gem.png'
    set_keys(KbRight => :move_right,
             KbLeft => :move_left,
             KbUp => :move_up,
             KbDown => :move_down)
  end

  def move_right
    @x += speed*dt
  end

  def move_left
    @x -= speed*dt
  end

  def move_up
    @y -= speed*dt
  end

  def move_down
    @y += speed*dt
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys KbEscape => :close
    set_game_path(__FILE__)
    load_resources 'media'

    @player = Player.new(self)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @cursor = Lotu::Cursor.new(self)
    puts "Example: #{__FILE__}"
  end

  def draw
    super
    @font.draw("FPS: #{@fps}", 10, 10, 0, 1.0, 1.0, 0xffffff00)
  end
end

Example.new.show
