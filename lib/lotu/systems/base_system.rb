module Lotu
  class BaseSystem

    def initialize(user, opts={})
      @user = user
    end

    def dt
      $lotu.dt
    end

    def draw; end
    def update; end

  end
end
