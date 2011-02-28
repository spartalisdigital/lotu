module Lotu
  module SystemUser

    attr_accessor :systems

    def self.included base
      base.extend ClassMethods
    end

    # PONDER: Cambiar por initialize? y controlar el punto de llamado
    # con super?
    def init_behavior user_opts
      super if defined? super
      @systems ||= Hash.new

      options_for_me = self.class.behavior_options[SystemUser]

      options_for_me && options_for_me.each do |klass, options|
        # add the behavior options to the user_opts hash
        # in case we need access to some level class config param
        user_opts.merge!(options)
        @systems[klass] = klass.new( self, user_opts )
      end
    end

    # Need to call this inside update
    def update
      super if defined? super
      @systems.each_value do |system|
        system.update
      end
    end

    # Need to call this inside draw
    def draw
      super if defined? super
      # Systems may report interesting stuff
      @systems.each_value do |system|
        system.draw
      end
    end

    # Allows to activate a system in the host
    module ClassMethods
      # specify the systems you want to use, using symbols
      # instead of module names
      def use_systems *system_names
        system_names.each do |system_name|
          if system_name.is_a? Symbol
            use Lotu.const_get("#{system_name.capitalize}System")
          elsif system_name.is_a? Hash
            system_name.each do |key,value|
              use Lotu.const_get("#{key.capitalize}System"), value
            end
          else
            raise "Unsupported system name as #{system_name.class}"
          end
        end
      end

      # specify the systems you want to use, using module names
      def use( klass, opts={} )
        behavior_options[SystemUser] ||= Hash.new
        behavior_options[SystemUser][klass] = opts
      end
    end

  end
end
