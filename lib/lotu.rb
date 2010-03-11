GAME_ROOT = File.expand_path(File.dirname($0))
LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'

require 'behaviors/controllable'
require 'behaviors/resourceful'
require 'behaviors/drawable'
require 'behaviors/input_controller'

require 'fps'
require 'actor'
require 'cursor'
require 'window'

module Lotu
  # General utility methods
  def self.game_path(path = '')
    File.join(GAME_ROOT, path)
  end
end
