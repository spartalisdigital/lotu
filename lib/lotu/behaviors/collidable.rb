module Lotu
  module Collidable

    def self.included base
      base.extend ClassMethods
    end

    def options_for klass
      self.class.behavior_options[klass]
    end

    def calc_radius
      if @width
        @collision_radius = @width/2.0 * @factor_x
      elsif @height
        @collision_radius = @height/2.0 * @factor_y
      else
        @collision_radius = 100
      end
    end

    def init_behavior opts
      super if defined? super

      calc_radius
      class << self
        attr_accessor :collision_radius
      end

      @collision_tag = options_for(Collidable)
      # TODO: Change @parent for @manager (could be a Game or a Scene)
      @parent.systems[CollisionSystem].add_entity(self, @collision_tag) if @parent.systems[CollisionSystem]
    end

    def collides_with(other)
      return false if self.equal? other
      Gosu.distance(@x, @y, other.x, other.y) < @collision_radius + other.collision_radius
    end

    def die
      super
      @parent.systems[CollisionSystem].remove_entity(self, @collision_tag) if @parent.systems[CollisionSystem]
    end

    module ClassMethods
      def collides_as tag
        behavior_options[Collidable] = tag
      end
    end

  end
end
