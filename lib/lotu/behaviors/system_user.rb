module Lotu
  module SystemUser

    attr_accessor :systems

    def self.included base
      base.extend ClassMethods
    end

    def init_behavior opts
      super if defined? super
      @systems ||= Hash.new

      self.class.behavior_options[SystemUser] &&
        self.class.behavior_options[SystemUser].each do |klass, options|
        @systems[klass] = klass.new( self, options.empty?? opts : options )
        #@systems[klass]
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
    module ClassMethods
      def use( klass, opts={} )
        behavior_options[SystemUser][klass] = opts
      end
    end

  end
end
