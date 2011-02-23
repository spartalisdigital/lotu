module Lotu
  module SystemUser

    attr_accessor :systems

    # Allows to activate a system in the host
    def use( klass, opts={} )
      @systems ||= Hash.new
      @systems[klass] = klass.new( self, opts )
      @systems[klass]
    end

    # Need to call this inside update
    def update_systems
      @systems.each_value do |system|
        system.update
      end
    end

    # Need to call this inside draw
    def draw_systems
      # Systems may report interesting stuff
      @systems.each_value do |system|
        system.draw
      end
    end

  end
end
