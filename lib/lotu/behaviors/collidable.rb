module Lotu
  module Collidable

    attr_accessor :collision_tags

    def self.included base
      base.extend ClassMethods
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
      @collision_tags = self.class.behavior_options[Collidable]
      setup_tags
    end

    def setup_tags
      # TODO: Change @parent for @manager (could be a Game or a Scene)
      @collision_tags.each do |tag, o|
        @parent.systems[CollisionSystem].add_entity(self, tag) if @parent.systems[CollisionSystem]
      end if @collision_tags
    end

    def collides_with(other)
      return false if self.equal? other
      Gosu.distance(@x, @y, other.x, other.y) < collision_radius + other.collision_radius
    end

    def die
      super if defined? super
      @collision_tags.each do |tag, options|
        @parent.systems[CollisionSystem].remove_entity(self, tag) if @parent.systems[CollisionSystem]
      end if @collision_tags
    end

    module ClassMethods
      def collides_as tag, opts={}
        behavior_options[Collidable] ||= Hash.new
        behavior_options[Collidable][tag] = opts
      end
    end

  end
end
