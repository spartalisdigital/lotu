# -*- coding: utf-8 -*-
module Lotu
  class Steering

    def initialize(actor)
      # Add new functionality to Actor
      actor.extend ActorMethods

      # Attributes
      @actor = actor
      @behaviors = {}
      @force = Vector2d.new
      @zero = Vector2d.new
    end

    def update
      @force.zero!
      @behaviors.each_pair do |behavior, active|
        @force += send(behavior) if active
      end

      @actor.accel = @force / @actor.mass
      @actor.accel.truncate!(@actor.max_force)

      max_angle = @actor.max_turn_rate.gosu_to_radians * @actor.dt
      new_velocity = @actor.vel + @actor.accel * @actor.dt
      angle_to_new_velocity = @actor.heading.angle_to(new_velocity).gosu_to_radians

      if angle_to_new_velocity.abs > max_angle
        sign = @actor.heading.sign_to(new_velocity)
        @actor.vel.x = Gosu.offset_x(max_angle * sign, new_velocity.length)
        @actor.vel.y = Gosu.offset_y(max_angle * sign, new_velocity.length)
      else
        @actor.vel = new_velocity
      end

      @actor.vel.truncate!(@actor.max_speed)
      @actor.pos += @actor.vel * @actor.dt

      if @actor.vel.length > 0.0001
        @actor.heading = @actor.vel.normalize
      end

      @actor.x = @actor.pos.x
      @actor.y = @actor.pos.y
      @actor.angle = @actor.heading.angle
    end

    def activate(behavior)
      @behaviors[behavior] = true
    end

    def deactivate(behavior)
      @behaviors[behavior] = false
    end

    # The steering behaviors themselves
    def seek
      return @zero if @actor.seek_target.nil?
      desired_velocity = (@actor.seek_target - @actor.pos).normalize * @actor.max_speed
      return desired_velocity - @actor.vel
    end

    module ActorMethods

      def self.extended(instance)
        instance.steering_setup
      end

      def steering_setup
        # Create accessors for the actor
        class << self
          attr_accessor :mass, :pos, :heading, :vel, :accel,
          :max_speed, :max_turn_rate, :max_force,
          :seek_target
        end

        # Some defaults
        @mass = 1
        @pos = Vector2d.new(@x, @y)
        offset_x = Gosu.offset_x(@angle, 1)
        offset_y = Gosu.offset_y(@angle, 1)
        @heading = Vector2d.new(offset_x, offset_y)
        @vel = Vector2d.new
        @accel = Vector2d.new
        @max_speed = 150
        @max_turn_rate = 180
        @max_force = 500
      end

      # to_s utility methods
      def to_s
        ["@angle(#{format('%.2f', @angle)}°)",
         "@pos(#{@pos})",
         "@heading(#{@heading})",
         "@vel(#{@vel})",
         "@accel(#{@accel})",
         "@seek_target(#{@seek_target})",
         "to @seek_target angle(#{format('%.2f', @heading.angle_to(@seek_target)) if @seek_target})"]
      end

    end

  end
end
