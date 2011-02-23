# -*- coding: utf-8 -*-
module Lotu
  class InterpolationSystem < BaseSystem

    def initialize(user, opts={})
      super
      user.extend(UserMethods)
      @interpolations = []
      @tagged_for_deletion = []
    end

    def interpolate(object, property, opts)
      interpolation = {
        :object => object,
        :property_getter => property,
        :property_setter => "#{property}=",
        :accum_time => 0,
        :calc => 0,
        :init => Float(opts[:init]),
        :end => Float(opts[:end]),
        :duration => opts[:duration] || 1,
        :start_in => opts[:start_in] || 0,
        :on_result => opts[:on_result],
        :loop => opts[:loop],
        :bounce => opts[:bounce],
        :bouncing_back => false
      }
      @interpolations << interpolation
    end

    # TODO: incluir código para :loop_for => n
    def update
      @interpolations.each do |t|
        t[:accum_time] += dt
        if t[:accum_time] > t[:start_in]
          step = ( t[:end] - t[:init] )/t[:duration] * dt
          t[:calc] += step
          tag_for_deletion( t ) if step == 0
          if( t[:init] + t[:calc] > t[:end] && step > 0 ) || ( t[:init] + t[:calc] < t[:end] && step < 0 )
            if t[:loop] || ( t[:bounce] && !t[:bouncing_back] )
              t[:calc] = 0
            else
              t[:calc] = t[:end] - t[:init]
              tag_for_deletion(t)
            end
            if t[:bounce]
              t[:bouncing_back] = !t[:bouncing_back]
              t[:init], t[:end] = t[:end], t[:init]
            end
          end
          value = t[:init] + t[:calc]
          value = value.send(t[:on_result]) if t[:on_result]
          t[:object].send( t[:property_setter], value )
        end
      end

      @tagged_for_deletion.each do |to_delete|
        #@interpolations.delete( to_delete )
        @interpolations.delete_if{ |i| i.object_id == to_delete.object_id }
      end.clear
    end

    def tag_for_deletion(interpolation)
      @tagged_for_deletion << interpolation
    end

    def to_s
      ["@interpolations.length #{@interpolations.length}",
       "@tagged_for_deletion.length #{@tagged_for_deletion.length}"]
    end

    module UserMethods
      def interpolate(object, property, opts)
        @systems[InterpolationSystem].interpolate(object, property, opts)
      end

      # Image helpers
      def interpolate_angle(opts)
        interpolate(self, :angle, opts)
      end

      def interpolate_width(opts)
        interpolate(self, :width, opts)
      end

      def interpolate_height(opts)
        interpolate(self, :height, opts)
      end

      # Color helpers
      def interpolate_alpha(opts)
        interpolate(@color, :alpha, opts.merge!(:on_result => :to_i))
      end

      def interpolate_red(opts)
        interpolate(@color, :red, opts.merge!(:on_result => :to_i))
      end

      def interpolate_green(opts)
        interpolate(@color, :green, opts.merge!(:on_result => :to_i))
      end

      def interpolate_blue(opts)
        interpolate(@color, :blue, opts.merge!(:on_result => :to_i))
      end

      def interpolate_hue(opts)
        interpolate(@color, :hue, opts)
      end

      def interpolate_saturation(opts)
        interpolate(@color, :saturation, opts)
      end

      def interpolate_value(opts)
        interpolate(@color, :value, opts)
      end
    end

  end
end
