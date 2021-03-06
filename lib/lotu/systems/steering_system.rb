# -*- coding: utf-8 -*-
module Lotu
  class SteeringSystem < BaseSystem

    def initialize(user, opts={})
      super

      # Add new functionality to Actor
      @user.extend UserMethods

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
      @user.mass = opts[:mass]
      @user.max_speed = opts[:max_speed]
      @user.max_turn_rate = opts[:max_turn_rate]
      @user.max_force = opts[:max_force]
      @user.wander_radius = opts[:wander_radius]
      @user.wander_distance = opts[:wander_distance]

      # More attributes
      @behaviors = {}
      @force = Vector2d.new
      @zero = Vector2d.new
      @user.pos.x = user.x
      @user.pos.y = user.y
    end

    def update
      @user.pos.x = @user.x
      @user.pos.y = @user.y

      @force.zero!
      @behaviors.each_pair do |behavior, active|
        @force += send(behavior) if active
      end

      @user.accel = @force / @user.mass
      @user.accel.truncate!(@user.max_force)

      max_angle = @user.max_turn_rate * @user.dt
      new_velocity = @user.vel + @user.accel * @user.dt
      angle_to_new_velocity = @user.heading.angle_to(new_velocity)

      if angle_to_new_velocity.abs > max_angle
        sign = @user.heading.sign_to(new_velocity)
        corrected_angle = @user.heading.angle + max_angle * sign
        @user.vel.x = Gosu.offset_x(corrected_angle, new_velocity.length)
        @user.vel.y = Gosu.offset_y(corrected_angle, new_velocity.length)
      else
        @user.vel = new_velocity
      end

      @user.vel.truncate!(@user.max_speed)
      @user.pos += @user.vel * @user.dt

      if @user.vel.length > 0.0001
        @user.heading = @user.vel.normalize
      end

      @user.x = @user.pos.x
      @user.y = @user.pos.y
      @user.angle = @user.heading.angle
    end

    def activate(behavior)
      @behaviors[behavior] = true
    end

    def deactivate(behavior)
      @behaviors[behavior] = false
    end

    # The steering behaviors themselves
    def seek
      return @zero if @user.target.nil?
      desired_velocity = (@user.target - @user.pos).normalize * @user.max_speed
      return desired_velocity - @user.vel
    end

    def flee
      return @zero if @user.target.nil?
      desired_velocity = (@user.pos - @user.target).normalize * @user.max_speed
      return desired_velocity - @user.vel
    end

    def arrive(deceleration = :normal)
      return @zero if @user.target.nil?
      deceleration_values = {
        :fast => 0.5,
        :normal => 1,
        :slow => 2
      }
      deceleration_tweaker = 1.0
      to_target = @user.target - @user.pos
      distance_to_target = to_target.length

      if distance_to_target > 10
        speed = distance_to_target / (deceleration_tweaker * deceleration_values[deceleration])
        speed = [speed, @user.max_speed].min
        desired_velocity = to_target * speed / distance_to_target
        return desired_velocity - @user.vel
      else
        @user.vel /= 1.15
        @user.accel /= 1.15
      end
      return @zero
    end

    def pursuit
      return @zero if @user.evader.nil?
      to_evader = @user.evader.pos - @user.pos
      relative_heading = @user.heading.dot(@user.evader.heading)
      if to_evader.dot(@user.heading) > 0 && relative_heading < -0.95
        @user.target = @user.evader.pos
        return seek
      end

      look_ahead_time = to_evader.length / (@user.max_speed + @user.evader.vel.length)
      predicted_position = @user.evader.pos + @user.evader.vel * look_ahead_time
      @user.target = predicted_position
      return seek
    end

    def evade
      return @zero if @user.pursuer.nil?
      to_pursuer = @user.pursuer.pos - @user.pos
      look_ahead_time = to_pursuer.length / (@user.max_speed + @user.pursuer.vel.length)
      predicted_position = @user.pursuer.pos + @user.pursuer.vel * look_ahead_time
      @user.target = @user.pursuer.pos
      return flee
    end

    def evade_multiple
      return @zero if @user.pursuers.empty?
      combined_velocities = Vector2d.new
      combined_positions = Vector2d.new
      @user.pursuers.each do |p|
        combined_velocities += p.vel
        combined_positions += p.pos
      end
      combined_velocities /= @user.pursuers.length
      combined_positions /= @user.pursuers.length
      to_pursuers = combined_positions - @user.pos
      look_ahead_time = to_pursuers.length / (@user.max_speed + combined_velocities.length)
      predicted_position = combined_positions + combined_velocities * look_ahead_time
      @user.target = combined_positions
      return flee
    end

    # TODO: Fix wander
    def wander
      wander_jitter = 10

      @user.wander_target += Vector2d.new(Gosu.random(-1,1), Gosu.random(-1,1))
      @user.wander_target.normalize!
      @user.wander_target *= @user.wander_radius
      target_local = @user.wander_target + Vector2d.new(0, @user.wander_distance)
      target_world = local_to_world(target_local, @user.heading, @user.heading.perp, @user.pos)
      return target_world - @user.pos
    end

    def local_to_world(local_target, heading, side, pos)
      local_angle = heading.angle_to(local_target)
      x = Gosu.offset_x(local_angle, local_target.length)
      y = Gosu.offset_y(local_angle, local_target.length)
      world_point = Vector2d.new(x, y) + pos
    end

    module UserMethods

      def self.extended(instance)
        instance.setup_steering
      end

      def setup_steering
        # Create accessors for the user
        class << self
          attr_accessor :mass, :pos, :heading, :vel, :accel,
          :max_speed, :max_turn_rate, :max_force,
          :wander_radius, :wander_distance, :wander_target,
          :target, :evader, :pursuer, :pursuers
        end

        # TODO: move these inside the SteeringSystem?
        # and just delegate with accessors?
        # Some defaults
        @pos = Vector2d.new(@x, @y)
        offset_x = Gosu.offset_x(@angle, 1)
        offset_y = Gosu.offset_y(@angle, 1)
        @heading = Vector2d.new(offset_x, offset_y)
        @vel = Vector2d.new
        @accel = Vector2d.new
        @wander_target = Vector2d.new
        @pursuers = []

        @colors = {
          :position => 0xff666666,
          :heading => 0xffff0000,
          :target => rand_color
        }
      end

      def activate(behavior)
        @systems[SteeringSystem].activate(behavior)
      end

      def distance_to_target
        (@target - @pos).length
      end

      def facing_target?
        @heading.facing_to?(@target - @pos)
      end

      def draw_debug
        super
        $lotu.draw_line(0, 0, @colors[:position], @pos.x, @pos.y, @colors[:position])
        $lotu.draw_line(@pos.x, @pos.y, @colors[:heading], (@pos + @heading*50).x, (@pos+@heading*50).y, @colors[:heading])
        $lotu.draw_line(@pos.x, @pos.y, @colors[:target], @target.x, @target.y, @colors[:target]) if @target
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
