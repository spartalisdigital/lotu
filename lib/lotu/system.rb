module Lotu
  class System

    def initialize(user, opts={})
      @user = user
      @user.extend (UserMethods) if defined? (UserMethods)
    end

    def dt
      $lotu.dt
    end

    def draw;end

  end
end
