#!/usr/bin/env ruby
LIB_PATH = File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lotu.rb')
require File.expand_path(LIB_PATH)

include Gosu::Button
include Lotu

class WarpingRuby < Actor
  def initialize(opts={})
    super
    set_image 'CptnRuby Gem.png'
  end

  def warp(x, y)
    @x, @y = x, y
  end
end

class Example < Game
  def initialize
    # This will call the hooks:
    # load_resources, setup_systems and setup_actors
    # declared in the parent class
    super
    # Custom setup methods for this class
    setup_input
    setup_events
  end

  def load_resources
    with_path_from_file(__FILE__) do
      load_images '../media'
    end
  end

  def setup_systems
    super
    use(FpsSystem)
    use(StalkerSystem, :stalk => [Actor, Cursor, WarpingRuby, TextBox, Object])
  end

  def setup_actors
    @ruby = WarpingRuby.new(:x => width/2, :y => height/2)
    @cursor1 = Cursor.new(:image => 'crosshair.png',
                          :keys => {MsLeft => [:click, false]},
                          :color => 0xff0099ff)
    @cursor2 = Cursor.new(:image => 'crosshair.png',
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

    # Create a TextBox with default option :size => 15
    @info = TextBox.new(:size => 15)
    @info.watch(@systems[FpsSystem])
    @info.watch(@systems[StalkerSystem])
    # We can change the size for a specific line of text
    @info.watch("@cursor1 data:", :size => 20)
    # Color too
    @info.watch(@cursor1, :color => 0xff0099ff)
    @info.watch("@cursor2 data:", :size => 20)
    @info.watch(@cursor2, :color => 0xff99ff00)
    @info.text("Move @cursor1 with mouse and @cursor2 with arrow keys (click with space!)")
  end

  def setup_input
    set_keys KbEscape => :close
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
