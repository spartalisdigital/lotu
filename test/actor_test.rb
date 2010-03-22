# -*- coding: utf-8 -*-
require 'rubygems'
require 'protest'
require 'rr'
require File.dirname(__FILE__) + '/../lib/lotu'
 
class Protest::TestCase
  include RR::Adapters::TestUnit
end
 
Protest.report_with(:documentation)
 
Protest.context('An Actor') do
  setup do
    $window = Lotu::Window.new
    @actor = Lotu::Actor.new
  end
 
  it 'has an x coordinate. (default: 0)' do
    assert_equal 0, @actor.x
  end
 
  it 'has an y coordinate. (default: 0)' do
    assert_equal 0, @actor.y
  end
 
  # faltaría el attr_reader :color en actor.rb
  #
  it 'has a color. (default: 0xffffffff)' do
    pending
    #assert_equal Gosu::Color::WHITE, @actor.color
  end
  
  it 'has a window reference.' do
    assert_equal $window, @actor.parent
  end
 
  # some context...
  #
  context 'when dying' do
    it 'removes itself from Window update_queue.' do
      mock.proxy($window.update_queue).delete(@actor)
      @actor.die
    end
  end
end
