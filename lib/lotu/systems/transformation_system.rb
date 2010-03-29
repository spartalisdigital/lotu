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
        :init => opts[:init],
        :end => opts[:end],
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

      def transform_angle(opts)
        transform(self, :angle, opts)
      end

      def transform_alpha(opts)
        transform(@color, :alpha, opts.merge!(:on_result => :to_i))
      end
    end

  end
end
