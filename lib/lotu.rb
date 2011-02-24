LOTU_ROOT = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(LOTU_ROOT)

require 'rubygems'
require 'gosu'
%w{vector2d string kernel util}.each{|file| require "helpers/#{file}"}
%w{resource_manager system_user collidable controllable eventful}.each{|file| require "behaviors/#{file}"}
%w{base interpolation animation input_manager stalker collision steering}.map{|s| "#{s}_system"}.each{|file| require "systems/#{file}"}
%w{behavior actor cursor text_box game}.each{|file| require file}

