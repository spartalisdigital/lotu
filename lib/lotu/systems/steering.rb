# -*- coding: utf-8 -*-
module Lotu
  class Steering
    attr_reader :force

    def initialize(actor, opts={})
      # Add new functionality to Actor
      actor.extend ActorMethods

      # Initialize attributes
      default_opts = {
        :mass => 1,
        :max_speed => 350,
        :max_turn_rate => 180,
        :max_force => 300,
        :wander_radius => 120,
        :wander_distance => 240.0
      }
      opts = default_opts.merge!(opts)

      actor.mass = opts[:mass]
      actor.max_speed = opts[:max_speed]
      actor.max_turn_rate = opts[:max_turn_rate]
      actor.max_force = opts[:max_force]
      actor.wander_radius = opts[:wander_radius]
      actor.wander_distance = opts[:wander_distance]

      # More attributes
      @actor = actor
      @behaviors = {}
      @force = Vector2d.new
      @zero = Vector2d.new
      actor.pos.x = actor.x
      actor.pos.y = actor.y
    end

    def update
      @force.zero!
      @behaviors.each_pair do |behavior, active|
        @force += send(behavior) if active
      end

      @actor.accel = @force / @actor.mass
      @actor.accel.truncate!(@actor.max_force)

      max_angle = @actor.max_turn_rate * @actor.dt
      new_velocity = @actor.vel + @actor.accel * @actor.dt
      angle_to_new_velocity = @actor.heading.angle_to(new_velocity)

      if angle_to_new_velocity.abs > max_angle
        sign = @actor.heading.sign_to(new_velocity)
        corrected_angle = @actor.heading.angle + max_angle * sign
        @actor.vel.x = Gosu.offset_x(corrected_angle, new_velocity.length)
        @actor.vel.y = Gosu.offset_y(corrected_angle, new_velocity.length)
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
      return @zero if @actor.target.nil?
      desired_velocity = (@actor.target - @actor.pos).normalize * @actor.max_speed
      return desired_velocity - @actor.vel
    end

    def flee
      return @zero if @actor.target.nil?
      desired_velocity = (@actor.pos - @actor.target).normalize * @actor.max_speed
      return desired_velocity - @actor.vel
    end

    def arrive(deceleration = :normal)
      return @zero if @actor.target.nil?
      deceleration_values = {
        :fast => 0.5,
        :normal => 1,
        :slow => 2
      }
      deceleration_tweaker = 1.0
      to_target = @actor.target - @actor.pos
      distance_to_target = to_target.length

      if distance_to_target > 10
        speed = distance_to_target / (deceleration_tweaker * deceleration_values[deceleration])
        speed = [speed, @actor.max_speed].min
        desired_velocity = to_target * speed / distance_to_target
        return desired_velocity - @actor.vel
      else
        @actor.vel /= 1.15
        @actor.accel /= 1.15
      end
      return @zero
    end

    def pursuit
      return @zero if @actor.evader.nil?
      to_evader = @actor.evader.pos - @actor.pos
      relative_heading = @actor.heading.dot(@actor.evader.heading)
      if to_evader.dot(@actor.heading) > 0 && relative_heading < -0.95
        @actor.target = @actor.evader.pos
        return seek
      end

      look_ahead_time = to_evader.length / (@actor.max_speed + @actor.evader.vel.length)
      predicted_position = @actor.evader.pos + @actor.evader.vel * look_ahead_time
      @actor.target = predicted_position
      return seek
    end

    def evade
      return @zero if @actor.pursuer.nil?
      to_pursuer = @actor.pursuer.pos - @actor.pos
      look_ahead_time = to_pursuer.length / (@actor.max_speed + @actor.pursuer.vel.length)
      predicted_position = @actor.pursuer.pos + @actor.pursuer.vel * look_ahead_time
      @actor.target = @actor.pursuer.pos
      return flee
    end

    # TODO: Fix wander
    def wander
      wander_jitter = 10

      @actor.wander_target += Vector2d.new(Gosu.random(-1,1), Gosu.random(-1,1))
      @actor.wander_target.normalize!
      @actor.wander_target *= @actor.wander_radius
      target_local = @actor.wander_target + Vector2d.new(0, @actor.wander_distance)
      target_world = local_to_world(target_local, @actor.heading, @actor.heading.perp, @actor.pos)
      return target_world - @actor.pos
    end

    def local_to_world(local_target, heading, side, pos)
      local_angle = heading.angle_to(local_target)
      x = Gosu.offset_x(local_angle, local_target.length)
      y = Gosu.offset_y(local_angle, local_target.length)
      world_point = Vector2d.new(x, y) + pos
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
          :wander_radius, :wander_distance, :wander_target,
          :target, :evader, :pursuer
        end

        # Some defaults
        @pos = Vector2d.new(@x, @y)
        offset_x = Gosu.offset_x(@angle, 1)
        offset_y = Gosu.offset_y(@angle, 1)
        @heading = Vector2d.new(offset_x, offset_y)
        @vel = Vector2d.new
        @accel = Vector2d.new
        @wander_target = Vector2d.new
      end

      def activate(behavior)
        @systems[Steering].activate(behavior)
      end

      def distance_to_target
        (@target - @pos).length
      end

      def facing_target?
        @heading.facing_to?(@target - @pos)
      end

      def draw
        super
        $window.draw_line(0, 0, 0xff999999, @pos.x, @pos.y, 0xff333333)
        $window.draw_line(@pos.x, @pos.y, 0xffffffff, (@pos + @heading*50).x, (@pos+@heading*50).y, 0xffff0000)
        $window.draw_line(@pos.x, @pos.y, 0xffffffff, @target.x, @target.y, 0xff00ff00) if @target
      end

      # to_s utility methods
      def to_s
        ["@angle(#{format('%.2f', @angle)}°)",
         "@pos(#{@pos})",
         "@heading(#{@heading})",
         "@vel |#{format('%.2f', @vel.length)}| (#{@vel})",
         "@accel |#{format('%.2f', @accel.length)}| (#{@accel})",
         "facing_target? #{facing_target? if @target}",
         "angle_to(@target) #{format('%.2f', @heading.angle_to(@target - @pos)) if @target}",
         "@seek_target(#{@target})"]
      end

    end

  end
end
