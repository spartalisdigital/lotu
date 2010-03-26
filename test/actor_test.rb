# -*- coding: utf-8 -*-
require 'rubygems'
require 'protest'
require 'rr'
require File.dirname(__FILE__) + '/../lib/lotu'

include Lotu

class Protest::TestCase
  include RR::Adapters::TestUnit
end
 
Protest.report_with(:documentation)
 
Protest.context('An Actor') do
  setup do
    @game = Game.new
    @actor = Actor.new
  end
 
  it 'has an x coordinate (default: 0)' do
    assert_equal 0, @actor.x
  end
 
  it 'has an y coordinate (default: 0)' do
    assert_equal 0, @actor.y
  end
 
  it 'has a color (default: 0xffffffff)' do
    assert_equal 0xffffffff, @actor.color
  end
  
  it 'has a parent reference == Game' do
    assert_equal @game, @actor.parent
  end

  context 'when creating' do
    it 'asks Game to manage it' do
      pending
      #crear método 'init' para poder probar esto?
    end
  end
 
  context 'when dying' do
    it 'asks Game to kill it' do
      mock.proxy(@game).kill_me(@actor)
      @actor.die
    end

    it 'is removed from Game update_queue' do
      mock.proxy(@game.update_queue).delete(@actor)
      @actor.die
    end

    it 'is removed from Game draw_queue' do
      mock.proxy(@game.update_queue).delete(@actor)
      @actor.die
    end
  end
end
