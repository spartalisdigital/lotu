module Lotu
  module Behavior

    def behave_like something
      include something
      class << self
        attr_accessor :behavior_options
      end
      @behavior_options ||= Hash.new
    end

    def inherited subclass
      subclass.behavior_options = behavior_options.deep_copy
    end

  end
end
