module Nario::Material
  class WeakBlock < Material
    BOUND_SPEED_RATE = -5

    def initialize(x, y, img=SDL::Surface.load("nario/image/weak_block.bmp"))
      super(x, y, img.w, img.h, img)
      @bound_speed = BOUND_SPEED_RATE
    end

    def foot_range
      {:x_range => (@x+@w/4)..(@x+@w-@w/4), :y_range => (@y+@h-@h/6)..(@y+@h), :event => :collide_itembox_foot}
    end

    def collide_nario_head(m)
      @movie_event = :bound
      @bound_prev_y = @y
      @frame = 0
    end

    def bound
      y_move(@bound_speed)
      @bound_speed += 3 if (@frame % 4).zero?
      if @y > @bound_prev_y
        @bound_speed = BOUND_SPEED_RATE
        @y = @bound_prev_y
        movie_end
      end
    end
  end
end
