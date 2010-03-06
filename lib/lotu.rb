GAME_ROOT = File.expand_path(File.dirname($0))
LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'
require 'controllable'

require 'behaviors/resourceful'
require 'behaviors/drawable'
require 'input_controller'
require 'actor'
require 'window'

module Lotu
  # General utility methods
  def self.game_path(path)
    File.join(GAME_ROOT, path)
  end
end
