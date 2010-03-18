#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class WarpingRuby < Lotu::Actor
  def initialize
    super
    set_image 'CptnRuby Gem.png'
  end

  def warp(x, y)
    @x, @y = x, y
  end
end

class Example < Lotu::Window
  def initialize
    super
    set_keys KbEscape => :close

    with_path __FILE__ do
      load_images '../media'
    end

    @ruby = WarpingRuby.new
    @cursor1 = Lotu::Cursor.new(:image => 'crosshair.png',
                                :keys => {MsLeft => [:click, false]})
    @cursor2 = Lotu::Cursor.new(:image => 'crosshair.png',
                                :use_mouse => false,
                                :keys => {
                                  KbSpace => [:click, false],
                                  KbUp => :up,
                                  KbDown => :down,
                                  KbLeft => :left,
                                  KbRight => :right
                                })

    @cursor1.on(:click) do |x,y|
      @ruby.warp(x,y)
    end
    @cursor2.on(:click) do |x,y|
      @ruby.warp(x,y)
    end
  end

  def draw
    super
    @fps_counter.draw
    @font.draw("@cursor1: #{@cursor1.clicked_x}, #{@cursor1.clicked_y}", 10, 30, 0, 1.0, 1.0, 0xfffff000)
    @font.draw("@cursor2: #{@cursor2.clicked_x}, #{@cursor2.clicked_y}", 10, 30+@font.height, 0, 1.0, 1.0, 0xfffff000)
  end
end

Example.new.show
