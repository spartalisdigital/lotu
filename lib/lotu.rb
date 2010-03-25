LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'gosu'
%w{vector2d string}.each{|file| require "misc/#{file}"}
%w{system_user collidable controllable drawable controllable/input_controller eventful}.each{|file| require "behaviors/#{file}"}
%w{stalker_system fps_system collision_system steering_system}.each{|file| require "systems/#{file}"}
%w{window actor cursor text_box}.each{|file| require file}
