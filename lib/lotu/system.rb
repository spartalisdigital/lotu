module Lotu
  class System

    def initialize(user, opts={})
      @user = user
    end

    def dt
      $lotu.dt
    end

    def draw;end

  end
end
