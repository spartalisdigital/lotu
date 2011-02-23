# -*- coding: utf-8 -*-
module Lotu
  class Vector2d
    attr_reader :x, :y

    def self.up
      @up ||= new(0, -1)
    end

    def initialize(x=0, y=0)
      clear_cache
      @x = Float(x)
      @y = Float(y)
    end

    def clear_cache
      @length = nil
      @length_sq = nil
      @normalized = false
    end

    def zero!
      self.x = 0
      self.y = 0
    end

    def zero?
      @x == 0 && @y == 0
    end

    def length
      @length ||= Math.sqrt(length_sq)
    end

    def length_sq
      @length_sq ||= @x*@x + @y*@y
    end

    def x=(x)
      clear_cache
      @x = Float(x)
    end

    def y=(y)
      clear_cache
      @y = Float(y)
    end

    def normalize
      if zero?
        Vector2d.new(0,0)
      else
        Vector2d.new(@x/length, @y/length)
      end
    end

    def normalize!
      if zero?
        @length = 0
        @length_sq = 0
        @normalized = true
      end

      return self if @normalized
      @x /= length
      @y /= length
      clear_cache
      @normalized = true
      self
    end

    def +(v)
      Vector2d.new(@x+v.x, @y+v.y)
    end

    def -(v)
      Vector2d.new(@x-v.x, @y-v.y)
    end

    def /(n)
      Vector2d.new(@x/n, @y/n)
    end

    def *(n)
      Vector2d.new(@x*n, @y*n)
    end

    def truncate!(max_l)
      return self if length < max_l
      normalize!
      self.x *= max_l
      self.y *= max_l
      self
    end

    def dot(v)
      @x*v.x + @y*v.y
    end

    def perp
      Vector2d.new(@y, -@x)
    end

    def angle
      Gosu.angle(0, 0, @x, @y)
    end

    def angle_to(v)
      Gosu.angle_diff(angle, v.angle)
    end

    def sign_to(vector)
      if @y * vector.x > @x * vector.y
        return -1
      else
        return 1
      end
    end

    def clockwise?(vector)
      sign_to(vector) == 1
    end

    def counter_clockwise?(vector)
      !clockwise?
    end

    def facing_to?(vector)
      dot(vector) > 0
    end

    def to_s
      # TODO tratar de reducir la cantidad de vectores creados, al
      # menos cuando no se está moviendo
      #format('%d %.2f, %.2f', object_id, @x, @y)
      format('%.2f, %.2f', @x, @y)
    end

  end
end
