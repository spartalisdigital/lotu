module Kernel

  # Taken from http://rubyworks.github.com/facets/doc/api/core/Kernel.html#method-i-deep_copy
  def deep_copy
    Marshal::load(Marshal::dump(self))
  end

end
