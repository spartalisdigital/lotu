module Lotu
  class TransformationSystem < System

    def initialize(user, opts={})
      super
      user.extend(UserMethods)
      @transformations = []
      @tagged_for_deletion = []
    end

    def transform(object, property, opts)
      transformation = {
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
        :loop => opts[:loop]
      }
      @transformations << transformation
    end

    def update
      @transformations.each do |t|
        t[:accum_time] += dt
        if t[:accum_time] > t[:start_in]
          step = (t[:end] - t[:init])/t[:duration] * dt
          t[:calc] += step
          if step > 0
            if t[:init] + t[:calc] > t[:end]
              if t[:loop]
                t[:calc] = 0
              else
                t[:calc] = t[:end] - t[:init]
                tag_for_deletion(t)
              end
            end
          else
            if t[:init] + t[:calc] < t[:end]
              if t[:loop]
                t[:calc] = 0
              else
                t[:calc] = t[:end] - t[:init]
                tag_for_deletion(t)
              end
            end
          end
          value = t[:init] + t[:calc]
          value = value.send(t[:on_result]) if t[:on_result]
          t[:object].send(t[:property_setter], value)
        end
      end

      @tagged_for_deletion.each do |to_delete|
        @transformations.delete(to_delete)
      end.clear
    end

    def tag_for_deletion(transform)
      @tagged_for_deletion << transform
    end

    def to_s
      ["@transformations.length #{@transformations.length}",
       "@tagged_for_deletion.length #{@tagged_for_deletion.length}"]
    end

    module UserMethods
      def transform(object, property, opts)
        @systems[TransformationSystem].transform(object, property, opts)
      end

      # Image helpers
      def transform_angle(opts)
        transform(self, :angle, opts)
      end

      def transform_width(opts)
        transform(self, :width, opts)
      end

      def transform_height(opts)
        transform(self, :height, opts)
      end

      # Color helpers
      def transform_alpha(opts)
        transform(@color, :alpha, opts.merge!(:on_result => :to_i))
      end

      def transform_red(opts)
        transform(@color, :red, opts.merge!(:on_result => :to_i))
      end

      def transform_green(opts)
        transform(@color, :green, opts.merge!(:on_result => :to_i))
      end

      def transform_blue(opts)
        transform(@color, :blue, opts.merge!(:on_result => :to_i))
      end

      def transform_hue(opts)
        transform(@color, :hue, opts)
      end

      def transform_saturation(opts)
        transform(@color, :saturation, opts)
      end

      def transform_value(opts)
        transform(@color, :value, opts)
      end
    end

  end
end
