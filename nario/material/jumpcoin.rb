module Nario::Material
  class JumpCoin < Material
    BOUND_SPEED_RATE = -12

    def initialize(x, y, img=SDL::Surface.load("nario/image/coin.bmp"))
      im = clean_bg(img.copy_rect(0, 0, 25, 42))
      im1 = clean_bg(img.copy_rect(25, 0, 25, 42))
      im2 = clean_bg(img.copy_rect(50, 0, 25, 42))
      im3 = clean_bg(img.copy_rect(75, 0, 25, 42))
      @bound_imgs = [im, im1, im2, im3, im2, im1, 0]
      super(x, y, im.w, im.h, im)
      @bound_speed = BOUND_SPEED_RATE
      @is_dead = true
      @bound_prev_y = @y
      @movie_event = :bound
    end

    def bound
      animate(@bound_imgs, 9)
      y_move(@bound_speed)
      @bound_speed += 3 if (@frame % 4).zero?
      if @y > @bound_prev_y
        @img = nil
        @is_garbage = true
        movie_end
      end
    end
  end
end
