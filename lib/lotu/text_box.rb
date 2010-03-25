# -*- coding: utf-8 -*-
module Lotu
  class TextBox < Actor

    def initialize(opts={})
      default_opts = {
        :size => 20
      }
      opts = default_opts.merge!(opts)
      super(opts)
      #TODO puede especificar a quién watchear y sus opciones de
      #dibujado en los parámetros
      @watch_list = []
      @size = opts[:size]
      @attached_to = opts[:attach_to]
      # Since we aren't setting an image for this, we need to specify
      # this actor needs to be drawed
      draw_me
    end

    def text(text, opts={})
      watch(text, opts)
    end

    def watch(subject, opts={})
      @watch_list << [subject, opts]
    end

    def attach_to(actor)
      @attached_to = actor
    end

    def update
      unless @attached_to.nil?
        @x = @attached_to.x + @attached_to.image.width / 2
        @y = @attached_to.y - @attached_to.image.height / 2
      end
    end

    def draw
      pos_y = 0
      @watch_list.each do |watched, opts|
        my_size = opts[:size] || @size
        my_color = opts[:color] || @color
        my_text = watched.to_s
        if my_text.is_a?(String)
          $window.fonts[my_size].draw(my_text, @x, @y + pos_y, @z, @factor_x, @factor_y, my_color)
          pos_y += my_size
        else
          my_text.each do |line|
            $window.fonts[my_size].draw(line, @x, @y + pos_y, @z, @factor_x, @factor_y, my_color)
            pos_y += my_size
          end
        end
      end
    end

  end
end
