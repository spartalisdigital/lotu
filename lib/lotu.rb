LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'rubygems'
require 'gosu'
%w{vector2d string}.each{|file| require "misc/#{file}"}
%w{resource_user system_user collidable controllable eventful}.each{|file| require "behaviors/#{file}"}
%w{game system actor cursor text_box}.each{|file| require file}
%w{interpolation animation input stalker collision steering}.map{|s| "#{s}_system"}.each{|file| require "systems/#{file}"}
