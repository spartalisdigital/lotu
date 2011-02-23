module Lotu
  module Collidable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior opts
      super if defined? super
      @collision_tag = nil
    end

    def collides_as(tag)
      @collision_tag = tag
      @parent.systems[CollisionSystem].add_entity(self, tag)
    end

    def collides_with(other)
      Gosu.distance(@x, @y, other.x, other.y) < @collision_radius + other.collision_radius
    end

    def die
      super
      @parent.systems[CollisionSystem].remove_entity(self, @collision_tag) if @parent.systems[CollisionSystem]
    end

  end
end
