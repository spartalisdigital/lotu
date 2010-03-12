# You can define arbitrary events on objects that include this module
# It serves as storage for code to be executed later (when fire is
# called)
# For example:
# class Cursor < Lotu::Actor
#   def initialize
#     on(:someone_clicked) do
#       puts 'Someone clicked me!'
#     end
#   end
# end
#
# After that you will be able to call #fire(:someone_clicked) from any
# instance of class Cursor.
# If you pair this with input handling, you will get a nice event
# system. Check out the Cursor class to see it in action.

module Lotu
  module Eventful
    def initialize(*args)
      super(*args)
      @_events = {}
    end

    def on(event, &blk)
      @_events[event] = blk
    end

    def fire(event, *args)
      @_events[event].call(*args) if @_events[event]
    end
  end
end
