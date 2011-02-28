# Get the path to this file to reference the lotu folder and stuff it
# in the front of $LOAD_PATH so our relative requires are found
# quickly without problems
LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'rubygems'
require 'gosu'

# Load helper files
['vector2d',
 'string',
 'kernel',
 'util'].each{|file| require "helpers/#{file}"}

# Load behavior files
['resource_manager',
 'system_user',
 'collidable',
 'controllable',
 'eventful'].each{|file| require "behaviors/#{file}"}

# Load system files
['base',
 'interpolation',
 'animation',
 'input_manager',
 'stalker',
 'collision',
 'steering'].map{|s| "#{s}_system"}.each{|file| require "systems/#{file}"}

# Load core files
['behavior',
 'actor',
 'cursor',
 'text_box',
 'game'].each{|file| require file}

