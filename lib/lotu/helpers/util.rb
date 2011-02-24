require 'optparse'

module Lotu
  module Helpers
    module Util

      def class_debug_info
        if $lotu.debug
          puts "[#{self.class.to_s.green}] Behavior options: #{self.class.behavior_options}\n" if self.class.respond_to? :behavior_options
        end
      end

      def instance_debug_info
        if $lotu.debug
          puts "[#{self.class.to_s.yellow}] Systems: #{systems.keys}\n" if systems
        end
      end

      # As seen in: http://ruby.about.com/od/advancedruby/a/optionparser.htm
      def parse_cli_options
        # This hash will hold all of the options
        # parsed from the command-line by
        # OptionParser.
        options = {}

        optparse = OptionParser.new do|opts|
          # Set a banner, displayed at the top
          # of the help screen.
          opts.banner = "Usage: #{$0} [options]"
          
          # Define the options, and what they do
          options[:debug] = false
          opts.on( '-d', '--debug', 'Output debug info' ) do
            options[:debug] = true
          end

          options[:fullscreen] = false
          opts.on( '-f', '--fullscreen', 'Runs the game in fullscreen mode' ) do
            options[:fullscreen] = true
          end
          
          # This displays the help screen, all programs are
          # assumed to have this option.
          opts.on( '-h', '--help', 'Display this screen' ) do
            puts opts
            exit
          end
        end

        # Parse the command-line. Remember there are two forms
        # of the parse method. The 'parse' method simply parses
        # ARGV, while the 'parse!' method parses ARGV and removes
        # any options found there, as well as any parameters for
        # the options. What's left is the list of files to resize.
        optparse.parse!

        puts "Showing debug info".red if options[:debug]
        puts "Running in fullscreen mode".red if options[:fullscreen]
        options
      end

    end
  end
end
