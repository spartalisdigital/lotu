module Lotu
  module SystemUser

    # Allows to activate a system in the host
    def use(klass, opts={})
      @systems[klass] = klass.new(self, opts)
    end

  end
end