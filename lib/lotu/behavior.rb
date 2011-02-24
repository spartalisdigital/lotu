module Lotu
  module Behavior

    def behave_like something
      include something
      class << self
        attr_accessor :behavior_options
      end
      @behavior_options ||= Hash.new{ |h,k| h[k] = {} }
    end

    def inherited subclass
      subclass.behavior_options =
        behavior_options.inject({}){ |hash, opts| hash[opts[0]] = opts[1].deep_copy; hash }
    end

  end
end
