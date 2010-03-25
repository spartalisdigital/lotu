module Lotu
  module Systems

    module Collision
      def self.extended(instance)
        instance.systems[:collision] = CollisionSystem.new
      end

      def when_colliding(*args, &blk)
        systems[:collision].when_colliding(*args, &blk)
      end
    end

    class CollisionSystem

      def initialize
        @entities = Hash.new{ |h,k| h[k] = [] }
        @actions = {}
      end

      def add_entity(obj, tag)
        @entities[tag] << obj
      end

      def remove_entity(obj, tag)
        @entities[tag].delete(obj)
      end

      def when_colliding(type1, type2, &blk)
        @actions[[type1, type2]] = blk
      end

      def update
        @actions.each do |tags, blk|
          @entities[tags[0]].each do |ent1|
            @entities[tags[1]].each do |ent2|
              blk.call(ent1, ent2) if ent1.collides_with(ent2)
            end
          end
        end
      end

      def draw;end

    end

  end
end
