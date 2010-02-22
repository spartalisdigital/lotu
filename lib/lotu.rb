framework_dir = File.expand_path(File.join(File.dirname(__FILE__), 'lotu'))
$LOAD_PATH.unshift(framework_dir)

require 'gosu'
require 'window'
require 'input_controller'
require 'actor'
