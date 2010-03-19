module Lotu
  module Collidable

    def self.extended(instance)
      instance.init_behavior
    end

    def init_behavior
      @collision_tag = nil
    end

    def collides_as(tag)
      @collision_tag = tag
      @parent.systems[:collision].add_entity(self, tag)
    end

    def collides_with(other)
      Gosu.distance(@x, @y, other.x, other.y) < @radius + other.radius
    end

    def die
      super
      @parent.systems[:collision].remove_entity(self, @collision_tag)
    end

  end
end
