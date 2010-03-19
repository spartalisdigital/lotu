LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'
%w{collidable controllable resourceful drawable controllable/input_controller eventful}.each{|file| require "behaviors/#{file}"}
%w{collision}.each{|file| require "systems/#{file}"}
%w{fps actor cursor window}.each{|file| require file}
