#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)
include Gosu::Button

class WarpingRuby < Lotu::Actor
  def initialize(opts={})
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
    load_resources
    setup_input
    setup_systems
    setup_actors
    setup_events

    @info = Lotu::TextBox.new
    @info.watch(@systems[Lotu::FpsSystem])
    @info.watch("@cursor1 data:")
    @info.watch(@cursor1, :color => 0xff0099ff, :size => 15)
    @info.watch("@cursor2 data:")
    @info.watch(@cursor2, :color => 0xff99ff00, :size => 15)
    @info.text("")
    @info.text("Move @cursor1 with mouse and @cursor2 with arrow keys (click with space!)", :size => 15)
  end

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media'
    end
  end

  def setup_input
    set_keys KbEscape => :close
  end

  def setup_systems
    use(Lotu::FpsSystem)
  end

  def setup_actors
    @ruby = WarpingRuby.new(:x => width/2, :y => height/2)
    @cursor1 = Lotu::Cursor.new(:image => 'crosshair.png',
                                :keys => {MsLeft => [:click, false]},
                                :color => 0xff0099ff)
    @cursor2 = Lotu::Cursor.new(:image => 'crosshair.png',
                                :use_mouse => false,
                                :keys => {
                                  KbSpace => [:click, false],
                                  KbUp => :up,
                                  KbDown => :down,
                                  KbLeft => :left,
                                  KbRight => :right},
                                :color => 0xff99ff00)
    @cursor2.x = width*3/4
    @cursor2.y = height/2
  end

  def setup_events
    @cursor1.on(:click) do |x,y|
      @ruby.warp(x,y)
    end
    @cursor2.on(:click) do |x,y|
      @ruby.warp(x,y)
    end
  end

end

Example.new.show
