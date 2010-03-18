LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'
%w{controllable resourceful drawable input_controller eventful}.each{|file| require "behaviors/#{file}"}
%w{fps actor cursor window}.each{|file| require file}
