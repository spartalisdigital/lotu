module Lotu
  module SystemUser

    attr_accessor :systems

    def setup_behavior
      super if defined? super
      @systems ||= Hash.new

      self.class.options[SystemUser][:use] &&
        self.class.options[SystemUser][:use].each do |k,v|
        use(k,v)
      end
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

    # Allows to activate a system in the host
    def use( klass, opts={} )
      @systems[klass] = klass.new( self, opts )
      @systems[klass]
    end

  end
end
