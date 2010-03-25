LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'
%w{fps vector2d string}.each{|file| require "misc/#{file}"}
%w{system_user collidable controllable drawable controllable/input_controller eventful}.each{|file| require "behaviors/#{file}"}
%w{collision steering}.each{|file| require "systems/#{file}"}
%w{window actor cursor text_box}.each{|file| require file}
