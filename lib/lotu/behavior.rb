module Lotu
  module Behavior
    include ClassLevelInheritableAttributes

    def behave_like something, opts={}
      cattr_inheritable :options
      include something

      @options ||= Hash.new{ |h,k| h[k] = Hash.new{ |i,j| i[j] = {} } }
      opts.each do |k,v|
        @options[something][k].merge!(opts[k])
      end
    end

  end
end
