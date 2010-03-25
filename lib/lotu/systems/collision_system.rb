module Lotu
  class CollisionSystem

    def initialize(user, opts={})
      user.extend UserMethods

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

    module UserMethods
      def when_colliding(*args, &blk)
        systems[CollisionSystem].when_colliding(*args, &blk)
      end
    end

  end
end
