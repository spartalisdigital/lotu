module Lotu
  module Behavior
    include ClassLevelInheritableAttributes

    def behave_like something, opts={}
      cattr_inheritable :behavior_options
      include something

      @behavior_options ||= Hash.new{ |h,k| h[k] = {} }
      @behavior_options[something].merge!(opts)
      #opts.each do |k,v|
      #  @behavior_options[something][k].merge!(opts[k])
      #end
    end

  end
end
